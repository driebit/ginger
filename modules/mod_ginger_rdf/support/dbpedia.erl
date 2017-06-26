-module(dbpedia).

-export([
    describe/1,
    describe/2
]).

-include("zotonic.hrl").

%% @doc http://wiki.dbpedia.org/about/language-chapters
-define(SPARQL_ENDPOINT, <<"http://{lang}.dbpedia.org/sparql">>).

describe(Resource) when is_list(Resource) ->
    describe(list_to_binary(Resource));
describe(<<"http://", _/binary>> = Resource) ->
    describe(Resource, <<>>).

describe(Resource, Language) when is_list(Resource); not is_binary(Language) ->
    describe(list_to_binary(Resource), z_convert:to_binary(Language));
describe(<<"http://", _/binary>> = Resource, Language) when Language =:= <<"nl">>; Language =:= <<>> ->
    Endpoint = binary:replace(?SPARQL_ENDPOINT, <<"{lang}.">>, <<Language/binary, ".">>),
    sparql_client:describe(Endpoint, Resource).
