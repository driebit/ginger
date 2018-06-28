-module(ginger_datetime).

-export([encode/1]).

-include("zotonic.hrl").

%% TODO: Test for valid datetime() not valid_date
-spec encode(calendar:datetime()) -> calendar:datetime().
encode({Date, _Time} = Value) ->
    case calendar:valid_date(Date) of
        true ->
            Value;
        _ ->
            ginger_type:error("datetime", Value)
    end;
encode(Value) ->
    ginger_type:error("datetime", Value).
