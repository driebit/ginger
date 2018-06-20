-module(ginger_number).

-export([encode/1]).

-include("zotonic.hrl").

-spec encode(term()) -> number().
encode(Value) when is_number(Value) ->
    Value;
encode(Value) ->
    erlang:error(<<"Expecting a number">>, Value).
