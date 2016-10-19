%% @doc Manage Ginger default ACL rules
-module(ginger_acl).
-author("Driebit <tech@driebit.nl").

-export([
    is_enabled/1,
    ensure_acl_rule/2,
    ensure_acl_rule/3,
    ensure_use_modules/3
]).

-include_lib("zotonic.hrl").

%% @doc Create ACL rule or re-create it if it has been removed.
-spec ensure_acl_rule(list(), #context{}) -> noop | list().
ensure_acl_rule(Props, Context) ->
    ensure_acl_rule(rsc, Props, Context).

-spec ensure_acl_rule(atom(), list(), #context{}) -> noop | list().
ensure_acl_rule(Kind, Props, Context) ->
    case acl_rule_exists(Kind, Props, Context) of
        true ->
            noop;
        false ->
            m_acl_rule:insert(
                Kind,
                Props,
                z_acl:sudo(Context)
            )
    end.

%% @doc Ensure that a user group can use a list of modules
-spec ensure_use_modules(atom(), list(), #context{}) -> ok.
ensure_use_modules(UserGroup, Modules, Context) ->
    lists:foreach(
        fun(Module) ->
            ginger_acl:ensure_acl_rule(
                module,
                [
                    {acl_user_group_id, m_rsc:rid(UserGroup, Context)},
                    {actions, [use]},
                    {module, Module}
                ],
                Context
            )
        end,
        Modules
    ).

%% @doc A simplistic test: return true when (at least) one rule already exists
%%      for the user group.
-spec acl_rule_exists(atom(), list(), #context{}) -> boolean().
acl_rule_exists(Kind, Props, Context) ->
    Filtered = lists:filter(
        fun(RuleProps) ->
            proplists:get_value(acl_user_group_id, RuleProps)
                == proplists:get_value(acl_user_group_id, Props)
        end,
        m_acl_rule:all_rules(Kind, publish, Context)
    ),
    case length(Filtered) of
        0 -> false;
        _ -> true
    end.

is_enabled(Context) ->
    Modules = z_module_manager:active(Context),
    lists:member(mod_content_groups, Modules) and lists:member(mod_acl_user_groups, Modules).
