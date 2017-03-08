-module(ginger_adlib_client).

-export([
    listdatabases/1,
    search/2
]).

-include_lib("zotonic.hrl").

listdatabases(Context) ->
    case request(mod_ginger_adlib:endpoint(Context), [{command, <<"listdatabases">>}]) of
        undefined ->
            [];
        #{<<"adlibJSON">> := #{<<"recordList">> := #{<<"record">> := Records}}} ->
            Records
    end.

search(Params, Context) ->
    request(mod_ginger_adlib:endpoint(Context), Params).
    
request(undefined, _Params) ->
    throw({error, adlib_url_must_be_defined});
request(Endpoint, Params) ->
    WithDefaultParams = [{output, json} | Params],
    Url = binary_to_list(Endpoint) ++ "?" ++ mochiweb_util:urlencode(WithDefaultParams),

    case httpc:request(Url) of
        {ok, {
            {_HTTP, 200, _OK},
            _Headers,
            Body
        }} ->
            jsx:decode(z_convert:to_binary(Body), [return_maps]);
        {ok, {
            {_HTTP, 404, _NotFound},
            _Headers,
            _Body
        }} ->
            lager:error("404: ~p", [Url]),
            undefined;
        Response ->
            lager:info("Adlib client error for URL ~p: ~p", [Url, Response]),
            undefined
    end.
