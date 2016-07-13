%% @doc Base JSON parser
-module(json_parser).

-include_lib("zotonic.hrl").

-export([
    parse/2
]).

parse({struct, Json}, _Fun) ->
    Json;
parse(Json, Fun) when is_list(Json) ->
    lists:map(
        fun({struct, Item}) ->
            lists:map(
                fun(KeyValue) ->
                    parse_property(KeyValue, Fun)
                end,
                Item
            )
        end,
        Json
    ).

parse_property({Key, null}, _Fun) ->
    {Key, null};
parse_property({Key, Value}, Fun) ->
    Fun({Key, Value}).
