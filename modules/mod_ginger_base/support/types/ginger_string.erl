-module(ginger_string).

-export([encode/1]).

-include("zotonic.hrl").

-spec encode(term()) -> binary().
encode(Value) ->
    case z_string:is_string(Value) of
        true ->
            z_convert:to_binary(Value);
        false ->
            erlang:error(<<"Invalid string">>, Value)
    end.


