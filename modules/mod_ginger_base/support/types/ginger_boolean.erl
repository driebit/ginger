-module(ginger_boolean).

-export([encode/1]).

-include("zotonic.hrl").

-spec encode(term()) -> boolean().
encode(Value) when is_boolean(Value) ->
    Value;
encode(Value) ->
    erlang:error(<<"Expecting a true or false atom">>, Value).
