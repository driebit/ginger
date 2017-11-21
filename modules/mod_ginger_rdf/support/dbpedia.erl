-module(dbpedia).

-export([
    search/1,
    describe/1,
    describe/2
]).

-include("zotonic.hrl").

%% @doc http://wiki.dbpedia.org/about/language-chapters
-define(SPARQL_ENDPOINT, <<"http://{lang}dbpedia.org/sparql">>).

search(#search_query{search = {dbpedia, Args}}) ->
    SparqlQuery = lists:foldl(
        fun({Key, Value}, Acc) ->
            parse_argument(Key, Value, Acc)
        end,
        <<"?s WHERE ">>,
        Args
    ),
    
    Language = z_convert:to_binary(proplists:get_value(lang, Args, <<>>)),
    Result = describe(SparqlQuery, Language),
    #search_result{result = [Result]}.

%% @doc Come up with alternative forms for RKD URIs, of which DBPedia has quite some.
parse_argument(rkd_uri, <<"https://rkd.nl/explore/artists/", Id/binary>> = Uri, Sparql) ->
    Clause = [
        <<"{?s <http://dbpedia.org/ontology/wikiPageExternalLink> <", Uri/binary, ">}">>, <<" UNION ">>,
        %% alternative URI
        <<"{?s <http://dbpedia.org/ontology/wikiPageExternalLink> <http://explore.rkd.nl/nl/explore/artists/", Id/binary, ">}">>, <<" UNION ">>,
        %% alternative property
        <<"{?s <http://nl.dbpedia.org/property/rkd> ", Id/binary, "}">>
    ],
    <<Sparql/binary, "{", (iolist_to_binary(Clause))/binary, "}">>;
parse_argument(same_as, Uri, Sparql) ->
    <<Sparql/binary, "{?s <http://www.w3.org/2002/07/owl#sameAs> <", Uri/binary, "}">>;
parse_argument(_, _, Sparql) ->
    Sparql.

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

endpoint(<<>>) ->
    binary:replace(?SPARQL_ENDPOINT, <<"{lang}">>, <<>>);
endpoint(Language) ->
    binary:replace(?SPARQL_ENDPOINT, <<"{lang}">>, <<Language/binary, ".">>).
