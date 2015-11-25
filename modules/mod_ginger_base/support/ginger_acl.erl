%% @doc Manage Ginger default ACL rules
-module(ginger_acl).
-author("Driebit <tech@driebit.nl").

-export([
    install/1,
    is_enabled/1,
    ensure_acl_rule/2,
    ensure_acl_rule/3,
    can_view/2
]).

-include_lib("zotonic.hrl").

%% @doc Instal lGinger default ACL rules
-spec install(#context{}) -> any().
install(Context) ->
    case is_enabled(Context) of
        false -> lager:info("mod_content_groups or mod_acl_user_groups not enabled so not installing ACL rules");
        true -> do_install(Context)
    end.

-spec do_install(#context{}) -> any().
do_install(Context) ->
    %% Anonymous can view everything
    ensure_acl_rule(
        [
            {acl_user_group_id, m_rsc:rid(acl_user_group_anonymous, Context)},
            {actions, ["view"]}
        ],
        Context
    ),
    %% Editors can edit everything, including resources created by other editors
    ensure_acl_rule(
        [
            {acl_user_group_id, m_rsc:rid(acl_user_group_editors, Context)},
            {actions, "view,insert,update,delete,link"},
            {content_group_id, m_rsc:rid(default_content_group, Context)}
        ],
        Context
    ),
    %% Editors can access the admin
    ensure_acl_rule(
        module,
        [
            {acl_user_group_id, m_rsc:rid(acl_user_group_editors, Context)},
            {actions, "use"},
            {module, "mod_admin"}
        ],
        Context
    ),
    %% Editors can configure the menu
    ensure_acl_rule(
        module,
        [
            {acl_user_group_id, m_rsc:rid(acl_user_group_editors, Context)},
            {actions, "use"},
            {module, "mod_menu"}
        ],
        Context
    ),
    m_acl_rule:publish(rsc, Context),
    m_acl_rule:publish(module, Context).

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

%% @doc When a resource is unpublished, only allow users with update rights on
%%      it to view the resource.
-spec can_view(integer(), #context{}) -> boolean() | undefined.
can_view(Id, Context) ->
    case m_rsc:p_no_acl(Id, is_published_date, Context) of
        undefined -> undefined;
        true -> undefined;
        false ->
            case z_acl:is_allowed(update, Id, Context) of
                true -> undefined;
                false -> false
            end
    end.
