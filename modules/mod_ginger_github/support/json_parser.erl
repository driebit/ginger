%% @doc Base JSON parser
-module(json_parser).

-include_lib("zotonic.hrl").

-export([
    parse/2
]).

parse({struct, List}, Fun) ->
    lists:map(
        fun(KeyValue) ->
            parse(KeyValue, Fun)
        end,
        List
    );
parse(Json, Fun) when is_list(Json) ->
    lists:map(
        fun({struct, Item}) ->
            lists:map(
                fun(KeyValue) ->
                    parse(KeyValue, Fun)
                end,
                Item
            )
        end,
        Json
    );
parse({Key, null}, _Fun) ->
    {Key, undefined};
parse({Key, {struct, _List} = Value}, Fun) ->
    {Key, parse(Value, Fun)};
parse({Key, Value}, Fun) ->
    Fun({Key, Value}).
