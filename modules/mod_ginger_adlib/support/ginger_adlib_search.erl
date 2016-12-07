-module(ginger_adlib_search).

-export([
    search/2
]).

-include("zotonic.hrl").

%% @doc See http://api.adlibsoft.com/site/api/functions/search
search(#search_query{search = {adlib, Args}, offsetlimit = {From, Size}}, Context) ->
    Params = [
        {startfrom, From},
        {limit, Size}
    | Args],

    Json = request(mod_ginger_adlib:endpoint(Context), Params),

    #{<<"adlibJSON">> := #{
        <<"recordList">> := #{
            <<"record">> := Records
        },
        <<"diagnostic">> := #{
            <<"hits">> := Hits
        }
    }} = jsx:decode(list_to_binary(Json), [return_maps]),

    ?DEBUG(Records),

    #search_result{result = Records, total = Hits}.

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
            Body;
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
