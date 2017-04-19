%% @doc Functions related to person resources
-module(ginger_person).
-author("Driebit <tech@driebit.nl").

-export([
    personal_name/1,
    personal_name/2
]).

-include_lib("zotonic.hrl").

%% @doc Join name properties together (e.g. for title)
personal_name(Properties) ->
    personal_name(Properties, [name_first, name_surname_prefix, name_surname]).

-spec personal_name(proplists:list(), list()) -> binary().
personal_name(Properties, Keys) ->
    Parts = [proplists:get_value(K, Properties) || K <- Keys],
    NonEmptyParts = lists:filter(fun(P) -> not z_utils:is_empty(P) end, Parts),
    StringParts = [z_convert:to_list(P) || P <- NonEmptyParts],
    iolist_to_binary(string:join(StringParts, " ")).



