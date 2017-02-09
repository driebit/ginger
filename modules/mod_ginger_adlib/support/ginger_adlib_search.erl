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
    search_result(jsx:decode(list_to_binary(Json), [return_maps])).

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

%% @doc Process search result.
%%      The only way to determine if there are results to be returned, is to
%%      look for the {"recordList": ...} JSON element.
-spec search_result(map()) -> #search_result{}.
search_result(#{<<"adlibJSON">> := #{<<"recordList">> := RecordList, <<"diagnostic">> := #{<<"hits">> := Hits}}}) ->
    #{<<"record">> := Records} = RecordList,
    #search_result{result = Records, total = binary_to_integer(Hits)};
search_result(#{<<"adlibJSON">> := #{<<"diagnostic">> := #{<<"hits">> := Hits}}}) ->
    #search_result{result = [], total = binary_to_integer(Hits)}.
