%% @doc Base HTTP/JSON client
-module(ginger_http_client).

-include_lib("zotonic.hrl").

-export([
    request/2
]).

request(Url, Headers) ->
    case httpc:request(get, {Url, Headers}, [], []) of
        {ok, {
            {_HTTP, StatusCode, _OK},
            _Headers,
            Body
        }} when StatusCode >= 400, StatusCode < 500 ->
            lager:error("~p error ~p for URL ~p: ~p", [?MODULE, StatusCode, Url, Body]),
            undefined;
        {ok, {
            {_HTTP, _StatusCode, _OK},
            _Headers,
            Body
        }} ->
            mochijson2:decode(Body);
        Response ->
            lager:error("~p unknown error for URL ~p: ~p", [?MODULE, Url, Response]),
            undefined
    end.
