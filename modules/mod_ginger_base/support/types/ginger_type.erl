-module(ginger_type).

-export([error/2]).

-include("zotonic.hrl").

-spec error(string(), term()) -> string().
error(Expected, Value) ->
    Expectation = "I was expecting the value to be: " ++ Expected,
    ActualValue = ", but it is: " ++ lists:flatten(io_lib:format("~p",[Value])),
    erlang:error(Expectation ++ ActualValue).

