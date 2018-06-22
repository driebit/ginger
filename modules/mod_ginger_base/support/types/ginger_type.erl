-module(ginger_type).

-export([error/2]).

-include("zotonic.hrl").

%% TODO: Improve code readabilty
-spec error(string(), term()) -> string().
error(Expected, Value) ->
    Message =
        [ newline(),
          color("Encoding error", "31"),
          newline(),
          "I was expecting the value to be: ", color(Expected, "32"),
          ", but it is: ",
          color(to_string(Value), "33"),
          newline(),
          newline()
        ],
    io:format(standard_error, lists:flatten(Message), []),
    erlang:error("***Unexpected value, see error message***").

-spec color(string(), string()) -> string().
color(Text, Color) ->
    "\e[" ++ Color ++"m" ++ Text ++ "\e[0m".

-spec newline() -> string().
newline() ->
    "~n".

-spec to_string(term()) -> string().
to_string(Term) ->
    lists:flatten(io_lib:format("~p",[Term])).
