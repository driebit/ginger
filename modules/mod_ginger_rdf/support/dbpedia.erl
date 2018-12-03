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
        <<"FILTER NOT EXISTS {?s <http://dbpedia.org/ontology/wikiPageRedirects> []} ">>,
        %% Only include resources that have a Wikipedia page.
        <<"FILTER EXISTS {?s <", (rdf_property:foaf(<<"isPrimaryTopicOf">>))/binary, "> []} ">>
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
    #search_result{result = query(Query, proplists:get_value(lang, Args, <<>>))}.

describe(Resource) when is_list(Resource) ->
    describe(list_to_binary(Resource));
describe(<<"http://", _/binary>> = Resource) ->
    describe(Resource, <<>>);
describe(Query) ->
    describe(Query, <<>>).

describe(Query, Language) when Language =:= <<"nl">>; Language =:= <<"wikidata">>; Language =:= <<>> ->
    sparql_client:describe(endpoint(Language), Query);
describe(Resource, Language) when not is_list(Resource); not is_binary(Language) ->
    describe(z_convert:to_binary(Resource), z_convert:to_binary(Language)).

-spec get_resource(binary(), binary()) -> m_rdf:rdf_resource() | undefined.
get_resource(Uri, Language) ->
    get_resource(Uri, default_properties(), Language).

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
                            Language =:= <<>>;
                            Language =:= "nl" ->
    sparql_client:query_rdf(endpoint(Language), Query).

endpoint(<<>>) ->
    binary:replace(?SPARQL_ENDPOINT, <<"{lang}">>, <<>>);
endpoint(Language) when is_list(Language) ->
    endpoint(list_to_binary(Language));
endpoint(Language) ->
    binary:replace(?SPARQL_ENDPOINT, <<"{lang}">>, <<Language/binary, ".">>).
