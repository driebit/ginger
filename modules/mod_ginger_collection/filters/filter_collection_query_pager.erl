%% @doc Return the previous and next item in the selected query.
-module(filter_collection_query_pager).

-export([
    collection_query_pager/5
]).

-include_lib("zotonic.hrl").

collection_query_pager(Search, Index, QueryId, "1", Context) ->
    Search2 = z_convert:to_atom(Search),
    #search_result{result = Ids} = z_search:search({Search2, [{query_id, QueryId}, {index, Index}]}, {1, 2}, Context),
    [undefined, lists:last(Ids)];
collection_query_pager(Search, Index, QueryId, Current, Context) ->
    Search2 = z_convert:to_atom(Search),
    Current2 = z_convert:to_integer(Current),
    #search_result{result = Ids} = z_search:search({Search2, [{query_id, QueryId}, {index, Index}]}, {Current2-1, 3}, Context),
    Next = case length(Ids) of
        2 -> undefined;
        _ -> lists:last(Ids)
    end,
    [hd(Ids), Next].
