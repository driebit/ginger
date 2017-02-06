-module(ginger_adlib_elasticsearch_mapping).

-export([
    map/1
]).

-include_lib("zotonic.hrl").


-callback map(Record :: map()) -> MappedRecord :: map().
-callback map_property({Property :: binary(), Value :: binary()}) -> {MappedProperty :: binary(), MappedValue :: binary()}.

map(Record) ->
    maps:fold(
        fun(Key, Value, Acc) ->
            case map_property({Key, Value}) of
                undefined ->
                    %% ignore
                    Acc;
                {NewKey, NewValue} ->
                    maps:put(NewKey, NewValue, Acc)
            end
        end,
        #{},
        Record
    ).

%% Map subtypes
map_property({<<"maker">> = Key, Creators}) ->
    {Key, [map(Creator) || Creator <- Creators, Creator =/= <<>>]};
map_property({<<"dimension">> = Key, Creators}) ->
    {Key, [map(Creator) || Creator <- Creators]};
map_property({<<"documentation">> = Key, Creators}) ->
    {Key, [map(Creator) || Creator <- Creators]};
map_property({<<"reproduction">> = Key, Creators}) ->
    {Key, [map(Creator) || Creator <- Creators]};

map_property({_, [<<"0000">>]}) ->
    %% Incorrect dates
    undefined;
map_property({_, [<<>>]}) ->
    %% Empty dates
    undefined;
map_property({Key, [SingleValue]}) ->
    map_property({Key, SingleValue});
map_property({<<"title.translation">>, Value}) ->
    {<<"title_translation">>, Value};
map_property({<<"title.type">>, Value}) ->
    {<<"title_type">>, Value};
map_property({<<"acquisition.date">> = Key, Value}) ->
    {Key, Value};
map_property({<<"creator">>, Value}) ->
    {<<"creator.name">>, Value};
map_property({Key, Value}) ->
    {Key, Value}.
