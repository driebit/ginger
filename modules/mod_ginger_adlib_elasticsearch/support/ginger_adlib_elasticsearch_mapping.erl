%% @doc Default
-module(ginger_adlib_elasticsearch_mapping).

-export([
    map/1,
    map_property/3,
    year/1
]).

-include_lib("zotonic.hrl").

-callback map_property(Property :: binary(), Value :: binary(), Acc :: map()) -> NewAcc :: map().

map(Record) ->
    Record.

map_property(<<"creator">>, Value, Acc) ->
    Acc#{<<"creator.name">> => Value};
map_property(Key, Value, Acc) when Key =:= <<"object_number">>; Key =:= <<"object.object_number">> ->
    Acc#{
        <<"dcterms:identifier">> => Value
    };
map_property(<<"production.date.start">> = Key, Value, Acc) ->
    Acc2 = Acc#{
        Key => Value,
        <<"dcterms:date">> => Value
    },
    case year(Value) of
        undefined ->
            Acc2;
        Year ->
            Acc2#{<<"dbo:productionStartYear">> => Year}
    end;
map_property(<<"production.date.end">> = Key, Value, Acc) ->
    Acc2 = Acc#{
        Key => Value,
        <<"dcterms:date">> => Value
    },
    case year(Value) of
        undefined ->
            Acc2;
        Year ->
            Acc2#{<<"dbo:productionEndYear">> => Year}
    end;
map_property(Key, Value, Acc) ->
    Acc#{Key => Value}.

%% @doc Extract YYYY value (removing '?' etc.)
year(Value) ->
    case re:run(Value, "^(\\d{4}).*$", [{capture, all_but_first, binary}]) of
        {match, [Year]} -> Year;
        _ -> undefined
    end.
