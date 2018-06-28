-module(ginger_type).

-export([error/2]).

-include("zotonic.hrl").

-spec error(string(), term()) -> string().
error(Expected, Value) ->
    Message =
        [ newline(),
          color("Encoding error", red),
          newline(),
          "I was expecting the value to be: ",
          color(Expected, green),
          ", but it is: ",
          color(to_string(Value), yellow),
          newline(),
          newline()
        ],
    io:format(standard_error, lists:flatten(Message), []),
    erlang:error("***Unexpected value, see error message***").

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

-spec color(string(), atom()) -> string().
color(Text, Color) ->
    "\e[" ++ toColorCode(Color) ++"m" ++ Text ++ "\e[0m".

-spec toColorCode(atom()) -> string().
toColorCode(red) ->
    "31";
toColorCode(green) ->
    "32";
toColorCode(yellow) ->
    "33";
toColorCode(_) ->
    "".

-spec newline() -> string().
newline() ->
    "~n".

-spec to_string(term()) -> string().
to_string(Term) ->
    lists:flatten(io_lib:format("~p",[Term])).

