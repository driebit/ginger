%% @doc A basic SPARQL client.
-module(sparql_client).

-export([
    describe/2
]).

-include_lib("zotonic.hrl").

describe(Endpoint, <<"https://", _/binary>> = Uri) ->
    describe(Endpoint, <<"<", Uri/binary, ">">>);
describe(Endpoint, <<"http://", _/binary>> = Uri) ->
    describe(Endpoint, <<"<", Uri/binary, ">">>);
describe(Endpoint, Clause) ->
    query(Endpoint, z_convert:to_binary(z_url:url_encode(<<"DESCRIBE ", Clause/binary>>))).
    
query(Endpoint, Query) ->
    Url = <<Endpoint/binary, "?query=", Query/binary>>,
    case ginger_http_client:get(Url, headers()) of
        undefined ->
            undefined;
        Map ->
            decode(Map)
    end.

decode(Data) ->
    ginger_json_ld:deserialize(Data).

headers() ->
    [
        {"Accept", "application/ld+json"}
    ].
