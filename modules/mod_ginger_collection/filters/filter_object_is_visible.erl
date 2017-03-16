%% @doc A visibility filter that also works for non-resources.
-module(filter_object_is_visible).

-export([
    object_is_visible/2
]).

-include_lib("zotonic.hrl").

object_is_visible([{_Key, _Value}|_] = Object, Context) ->
    object_is_visible([Object], Context);
object_is_visible(Objects, Context) ->
    lists:filter(
        fun(Object) ->
            ?DEBUG(Object),
            z_acl:is_allowed(view, map(Object), Context)
        end,
        Objects
    ).

%% @doc Convert proplist to map for easier pattern matching in is_allowed
%%      observers.
map(Object) when is_list(Object) ->
    maps:from_list(Object);
map(Object) ->
    Object.


