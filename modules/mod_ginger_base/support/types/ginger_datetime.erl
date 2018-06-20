-module(ginger_datetime).

-export([encode/1]).

-include("zotonic.hrl").

encode(Value) ->
    case calendar:valid_date(Value) of
        true ->
            Value;
        false ->
            erlang:error(<<"Expecting date()">>, Value)
    end.
