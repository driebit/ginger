%% @doc A simple HTTP/JSON client that wraps httpc and jsx.
-module(ginger_http_client).

-include_lib("zotonic.hrl").

-export([
    get/1,
    get/2,
    post/3,
    request/2,
    request/4
]).

%% @doc GET a URL.
-spec get(string()) -> map() | undefined.
get(Url) ->
    get(Url, []).

%% @doc GET a URL.
-spec get(string(), list()) -> map() | undefined.
get(Url, Headers) ->
    request(get, Url, Headers).

post(Url, Headers, Data) ->
    request(post, Url, Headers, Data).

request(Url, Headers) ->
    lager:error("ginger_http_client:request/2 is deprecated and will be removed; use ginger_http_client:get/2 instead."),
    get(Url, Headers).

%% @doc Do an HTTP request.
-spec request(atom(), string(), proplists:proplist()) -> map() | undefined.
request(Method, Url, Headers) when is_map(Headers) ->
    ListHeaders = lists:map(
        fun({Header, Value}) ->
            {z_convert:to_list(Header), z_convert:to_list(Value)}
        end,
        maps:to_list(Headers)
    ),
    request(Method, Url, ListHeaders);

request(Method, Url, Headers) when is_binary(Url) ->
    request(Method, binary_to_list(Url), Headers);
request(get, Url, Headers) ->
    lager:debug("ginger_http_client GET: ~s ~p", [Url, Headers]),

    case handle_response(httpc:request(get, {Url, Headers}, [], []), Url) of
        {error, _} ->
            undefined;
        Response ->
            decode(Response)
    end.

request(RequestMethod, Url, Headers, Data) ->
    JsonData = jsx:encode(Data),
    case handle_response(httpc:request(RequestMethod, {Url, Headers, "application/json", JsonData}, [], []), Url) of
        {error, _} ->
            undefined;
        Response ->
            decode(Response)
    end.

handle_response(Response, Url) ->
    case Response of
        {ok, {
            {_HTTP, StatusCode, _OK},
            _Headers,
            Body
        }} when StatusCode >= 400 ->
            lager:error("~p error ~p for URL ~p: ~p", [?MODULE, StatusCode, Url, Body]),
            {error, {StatusCode, list_to_binary(Body)}};
        {ok, {
            {_HTTP, _StatusCode, _OK},
            Headers,
            Body
        }} ->
            {proplists:get_value("content-type", Headers), list_to_binary(Body)};
        JsonResponse ->
            lager:error("~p unknown error for URL ~p: ~p", [?MODULE, Url, JsonResponse]),
            {error, JsonResponse}
    end.

%% @doc Decode the response based on Content-Type.
decode({"application/json" ++ _, Body}) ->
    jsx:decode(Body, [return_maps]);
decode({"application/ld+json" ++ _, Body}) ->
    jsx:decode(Body, [return_maps]);
decode({_ContentType, Body}) ->
    Body.
