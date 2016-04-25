%% @doc Manage Ginger default ACL rules
-module(ginger_logger).
-author("Driebit <tech@driebit.nl").

-export([
    deprecated/2
]).

-include_lib("zotonic.hrl").

%% @doc Log module deprecation
-spec deprecated(atom(), #context{}) -> any().
deprecated(Module, Context) ->
    lager:warning(
        "[~p] ~p is deprecated and will be removed",
        [z_context:site(Context), Module]
    ).
