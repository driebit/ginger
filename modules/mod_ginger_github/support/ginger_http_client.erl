%% @doc Base HTTP/JSON client
-module(ginger_http_client).

-include_lib("zotonic.hrl").

-export([
    request/2,
    request/4,
    request/5
]).

-spec request(string(), list()) -> list().
request(Url, Headers) ->
    case handle_response(httpc:request(get, {Url, Headers}, [], []), Url) of
        {error, _} ->
            undefined;
        ResponseBody ->
            mochijson2:decode(ResponseBody)
    end.

-spec request(string(), string(), list(), list()) -> list().
request(RequestMethod, Url, Headers, Data) ->
    request(RequestMethod, Url, Headers, Data, fun mochijson2:decode/1).

-spec request(string(), string(), list(), list(), fun()) -> list().
request(RequestMethod, Url, Headers, Data, DecodeFun) ->
    JsonData = encode_data(Data),
    case handle_response(httpc:request(RequestMethod, {Url, Headers, "application/json", JsonData}, [], []), Url) of
        {error, _} ->
            undefined;
        ResponseBody ->
            DecodeFun(ResponseBody)
    end.

handle_response(Response, Url) ->
    case Response of
        {ok, {
            {_HTTP, StatusCode, _OK},
            _Headers,
            Body
        }} when StatusCode >= 400 ->
            lager:error("~p error ~p for URL ~p: ~p", [?MODULE, StatusCode, Url, Body]),
            {error, {StatusCode, Body}};
        {ok, {
            {_HTTP, _StatusCode, _OK},
            _Headers,
            Body
        }} ->
            Body;
        JsonResponse ->
            lager:error("~p unknown error for URL ~p: ~p", [?MODULE, Url, JsonResponse]),
            {error, JsonResponse}
    end.

encode_data(Data) ->
    iolist_to_binary(mochijson2:encode(z_convert:to_json(Data))).
