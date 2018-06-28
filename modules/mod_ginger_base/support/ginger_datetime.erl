-module(ginger_datetime).

-export([encode/1]).

-include("zotonic.hrl").

-spec encode(calendar:datetime()) -> calendar:datetime().
encode({Date, Time} = Value) ->
    case {calendar:valid_date(Date), valid_time(Time)} of
        {true, true} ->
            Value;
        _ ->
            ginger_type:error("datetime", Value)
    end;
encode(Value) ->
    ginger_type:error("datetime", Value).


valid_time({H, M, S}) ->
    (H >= 0) and (H =< 23) and (M >= 0) and (M =< 59) and (S >= 0) and (S =< 59).
