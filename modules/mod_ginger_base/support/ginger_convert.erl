%% @doc Utilities for data conversion
-module(ginger_convert).

-export([
    maps_to_proplists/1,
    structs_to_maps/1,
    maps_to_structs/1
]).

% @doc Recursively converts all maps into proplists and lists
maps_to_proplists(Vals) when is_list(Vals) ->
    lists:map(
        fun
            ({Key, Value}) -> {Key, maps_to_proplists(Value)};
            (Val) -> maps_to_proplists(Val)
        end,
        Vals
    );
maps_to_proplists(Val) when is_map(Val) ->
    maps_to_proplists(maps:to_list(Val));
maps_to_proplists(Val) ->
    Val.

% @doc Recursively converts all mochijson structs into maps and lists
structs_to_maps({struct, Props}) when is_list(Props) ->
    lists:foldl(
        fun({Key, Val}, Map) ->
            Map#{Key => structs_to_maps(Val)}
        end,
        #{},
        Props
    );
structs_to_maps(Vals) when is_list(Vals) ->
    lists:map(fun structs_to_maps/1, Vals);
structs_to_maps(Val) ->
    Val.

% @doc Recursively converts all maps into mochisjon structs
maps_to_structs(Val) when is_map(Val) ->
    maps:fold(
        fun(Key, Value, {struct, Props}) ->
            {struct, [{Key, maps_to_structs(Value)}|Props]}
        end,
        {struct, []},
        Val
    );
maps_to_structs(Vals) when is_list(Vals) ->
    lists:map(fun maps_to_structs/1, Vals);
maps_to_structs(Val) ->
    Val.
