%% @doc Base HTTP/JSON client
-module(ginger_http_client).

-include_lib("zotonic.hrl").

-export([
    request/2,
    request/4
]).

-spec request(string(), list()) -> list().
request(Url, Headers) ->
    handle_response(httpc:request(get, {Url, Headers}, [], []), Url).

-spec request(string(), string(), list(), list()) -> list().
request(RequestMethod, Url, Headers, Data) ->
    JsonData = encode_data(Data),
    handle_response(httpc:request(RequestMethod, {Url, Headers, "application/json", JsonData}, [], []), Url).

handle_response(Response, Url) ->
    case Response of
        {ok, {
            {_HTTP, StatusCode, _OK},
            _Headers,
            Body
        }} when StatusCode >= 400 ->
            lager:error("~p error ~p for URL ~p: ~p", [?MODULE, StatusCode, Url, Body]),
            undefined;
        {ok, {
            {_HTTP, _StatusCode, _OK},
            _Headers,
            Body
        }} ->
            mochijson2:decode(Body);
        JsonResponse ->
            lager:error("~p unknown error for URL ~p: ~p", [?MODULE, Url, JsonResponse]),
            undefined
    end.

encode_data(Data) ->
    iolist_to_binary(mochijson2:encode(z_convert:to_json(Data))).
