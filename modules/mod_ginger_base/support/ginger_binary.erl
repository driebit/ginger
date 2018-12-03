%% Utility functions for working with binaries.
-module(ginger_binary).

-export([
    join/2
]).

%% @doc Join a list of binaries.
-spec join([binary()], binary()) -> binary().
join(List, Separator) ->
    Parts = [binary_to_list(Part) || Part <- List],
    String = string:join(Parts, binary_to_list(Separator)),
    list_to_binary(String).

