%% @doc Maps an Adlib record map to an Elasticsearch document.
-module(ginger_adlib_elasticsearch_mapper).

-export([
    map/2
]).

-include_lib("zotonic.hrl").

%% @doc Maps an Adlib record to an Elasticsearch document, taking care of nested
%%      fields. As Mapping, pass a module that implements behaviour
%%      ginger_adlib_elasticsearch_mapping.
-spec map(map(), module()) -> term() | map().
map(Map, Mapping) ->
    maps:fold(
        fun(Key, Value, Acc) when is_map(Value) ->
            Mapped = map(Value, Mapping),
            map_property(Key, Mapped, Acc, Mapping);
        (Key, Value, Acc) ->
            %% when is_map(Value)
            map_property(Key, Value, Acc, Mapping)
        end,
        #{},
        Map
    ).

map_property(_, [<<"0000">>], Acc, _Mapping) ->
    %% Incorrect dates
    Acc;
map_property(_, [<<>>], Acc, _Mapping) ->
    %% Empty dates
    Acc;
map_property(_, <<>>, Acc, _Mapping) ->
    Acc;
map_property(Key, [SingleValue], Acc, Mapping) ->
    ?DEBUG({single, Key, SingleValue}),
    map_property(Key, SingleValue, Acc, Mapping);
%%map_property(Key, Value, Acc, Mapping) when is_map(Value) ->
%%    MappedValue = map(Value, Mapping),
%%    Acc#{Key => MappedValue};
%%map_property(Key, Value, Acc, Mapping) when is_list(Value) ->
%%    %% Map any value that is itself a map.
%%    Acc#{Key => lists:filtermap(
%%        fun(V) when is_map(V) ->
%%            {true, map(V, Mapping)};
%%        (<<>>) ->
%%            false;
%%        (V) ->
%%            {true, V}
%%        end,
%%        Value
%%    )};
map_property(Key, Value, Acc, Mapping) ->
    Mapping:map_property(Key, Value, Acc).
