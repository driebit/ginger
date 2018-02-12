%% @doc A basic SPARQL client.
-module(sparql_client).

-export([
    describe/2,
    query/2,
    query/3
]).

-include_lib("zotonic.hrl").

describe(Endpoint, <<"https://", _/binary>> = Uri) ->
    describe(Endpoint, <<"<", Uri/binary, ">">>);
describe(Endpoint, <<"http://", _/binary>> = Uri) ->
    describe(Endpoint, <<"<", Uri/binary, ">">>);
describe(Endpoint, Clause) ->
    query(Endpoint, (<<"DESCRIBE ", Clause/binary>>)).
    
query(Endpoint, Query) ->
    query(Endpoint, Query, headers()).

-spec query(binary(), binary(), map()) -> list().
query(Endpoint, Query, Headers) ->
    Qs = z_convert:to_binary(z_url:url_encode(Query)),
    Url = <<Endpoint/binary, "?query=", Qs/binary>>,
    case ginger_http_client:get(Url, Headers) of
        undefined ->
            undefined;
        Map ->
            decode(Map)
    end.

decode(#{<<"@graph">> := _} = Data) ->
    ginger_json_ld:deserialize(Data);
decode(Data) ->
    Data.

headers() ->
    #{<<"Accept">> => <<"application/ld+json">>}.
