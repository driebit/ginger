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
    
    case ginger_adlib_client:search(Params, Context) of
        undefined ->
            undefined;
        Response ->
            search_result(Response)
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
