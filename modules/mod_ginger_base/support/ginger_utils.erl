-module(ginger_utils).

-export([
    unique/1
]).

%% @doc De-duplicate elements in list, preserving order.
-spec unique(list()) -> list().
unique(List) ->
    unique(List, []).

unique([], Acc) ->
    lists:reverse(Acc);
unique([H | T], Acc) ->
    case lists:member(H, Acc) of
        true ->
            unique(T, Acc);
         false ->
             unique(T, [H | Acc])
    end.
