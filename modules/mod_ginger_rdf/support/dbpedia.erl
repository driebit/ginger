-module(dbpedia).

-export([
    search/1,
    describe/1,
    describe/2,
    get_resource/2,
    get_resource/3
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

%% @doc http://wiki.dbpedia.org/about/language-chapters
-define(SPARQL_ENDPOINT, <<"http://{lang}dbpedia.org/sparql">>).

%% @doc Execute a search at one of the DBPedia SPARQL endpoints.
-spec search(#search_query{}) -> #search_result{}.
search(#search_query{search = {dbpedia, Args}, offsetlimit = {Offset, Limit}}) ->
    Predicates = proplists:get_value(properties, Args, default_properties()),
    Wheres = [parse_argument(Key, Value) || {Key, Value} <- Args] ++ [
        %% Exclude redirect pages.
        <<"FILTER NOT EXISTS {?s <http://dbpedia.org/ontology/wikiPageRedirects> []} ">>
    ],
    Query =
        sparql_query:limit(Limit,
            sparql_query:offset(Offset,
                sparql_query:and_where(iolist_to_binary(Wheres),
                    sparql_query:distinct(
                        sparql_query:select(Predicates)
                    )
                )
            )
        ),
    Language = z_convert:to_binary(proplists:get_value(lang, Args, <<>>)),
    #search_result{result = query(Query, Language)}.

describe(Resource) when is_list(Resource) ->
    describe(list_to_binary(Resource));
describe(<<"http://", _/binary>> = Resource) ->
    describe(Resource, <<>>);
describe(Query) ->
    describe(Query, <<>>).

describe(Query, Language) when not is_binary(Query) ->
    describe(z_convert:to_binary(Query), Language);
describe(Query, Language) when not is_binary(Language) ->
    describe(Query, z_convert:to_binary(Language));
describe(Query, Language) ->
    sparql_client:describe(endpoint(Language), Query).

-spec get_resource(binary(), binary()) -> m_rdf:rdf_resource() | undefined.
get_resource(Uri, Language) ->
    case get_resource(Uri, default_properties(), Language) of
        #rdf_resource{ id = SubjectUri, triples = Triples } = Resource ->
            case has_predicate(rdf_property:'dbpedia-owl'(<<"thumbnail">>), Triples) of
                false ->
                    case get_resource_thumbnail(SubjectUri) of
                        #rdf_resource{ triples = ThumbTriples } ->
                            Resource#rdf_resource{ triples = Triples ++ ThumbTriples };
                        undefined ->
                            Resource
                    end;
                true ->
                    Resource
            end;
        undefined ->
            undefined
    end.

%% @doc The nl dbpedia is missing the thumbnails of entries. Check if dbpedia.org
%% has a thumbnail.
get_resource_thumbnail(<<"http://nl.dbpedia.org/", Rest/binary>>) ->
    Uri = <<"http://dbpedia.org/", Rest/binary>>,
    get_resource(Uri, thumbnail_properties(), <<>>);
get_resource_thumbnail(_Uri) ->
    undefined.

has_predicate(Predicate, Triples) ->
    lists:any(
        fun(#triple{ predicate = P }) -> P =:= Predicate end,
        Triples).

-spec get_resource(binary(), [binary()], binary()) -> m_rdf:rdf_resource() | undefined.
get_resource(Uri, Properties, Language) ->
    sparql_client:get_resource(endpoint(Language), Uri, Properties).

%% @doc List of default properties that will be bound and retrieved in SPARQL queries.
-spec default_properties() -> [binary()].
default_properties() ->
    [
        rdf_property:rdfs(<<"label">>),
        rdf_property:'dbpedia-owl'(<<"thumbnail">>),
        rdf_property:'dbpedia-owl'(<<"abstract">>),
        rdf_property:foaf(<<"isPrimaryTopicOf">>),
        <<"http://nl.dbpedia.org/property/naam">>
    ].

%% @doc In the nl dbpedia we miss the thumbnail, fetch it from the 'en' dbpedia.
-spec thumbnail_properties() -> [binary()].
thumbnail_properties() ->
    [
        rdf_property:'dbpedia-owl'(<<"thumbnail">>)
    ].

%% @doc Come up with alternative forms for RKD URIs, of which DBPedia has quite some.
-spec parse_argument(atom(), binary()) -> binary().
parse_argument(rkd_uri, <<"https://rkd.nl/explore/artists/", Id/binary>> = Uri) ->
    Clause = [
        <<"{?s <http://dbpedia.org/ontology/wikiPageExternalLink> <", Uri/binary, ">}">>, <<" UNION ">>,
        %% alternative URI
        <<"{?s <http://dbpedia.org/ontology/wikiPageExternalLink> <http://explore.rkd.nl/nl/explore/artists/", Id/binary, ">}">>, <<" UNION ">>,
        %% alternative property
        <<"{?s <http://nl.dbpedia.org/property/rkd> ", Id/binary, "}">>
    ],
    <<"{", (iolist_to_binary(Clause))/binary, "}">>;
parse_argument(same_as, Uri) ->
    <<"{?s <http://www.w3.org/2002/07/owl#sameAs> <", Uri/binary, "}">>;
parse_argument(cat, Cat) ->
    <<"{?s a ", Cat/binary, "}">>;
parse_argument(text, Text) ->
    Text2 = z_convert:to_binary(Text),
    <<
        "{?s rdfs:label ?label. ?label bif:contains \"'", Text2/binary, "'\" }",
        " UNION {?s <http://nl.dbpedia.org/property/naam> ?name. ?name bif:contains \"'", Text2/binary, "'\"}"
    >>;
parse_argument(_, _) ->
    <<>>.

query(Query, Language) when Language =:= <<"nl">>;
                            Language =:= <<"wikidata">>;
                            Language =:= <<>> ->
    sparql_client:query_rdf(endpoint(Language), Query).

endpoint(Language) when is_list(Language) ->
    endpoint(list_to_binary(Language));
endpoint(<<>>) ->
    binary:replace(?SPARQL_ENDPOINT, <<"{lang}">>, <<>>);
endpoint(<<"en">>) ->
    binary:replace(?SPARQL_ENDPOINT, <<"{lang}">>, <<>>);
endpoint(Language) ->
    binary:replace(?SPARQL_ENDPOINT, <<"{lang}">>, <<Language/binary, ".">>).
