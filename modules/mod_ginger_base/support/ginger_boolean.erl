-module(ginger_boolean).

-export([encode/1]).

-include("zotonic.hrl").

-spec encode(term()) -> boolean().
encode(Value) when is_boolean(Value) ->
    Value;
encode(Value) ->
    ginger_type:error("boolean", Value).
