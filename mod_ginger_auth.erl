%% @author Driebit <tech@driebit.nl>
%% @copyright 2015

-module(mod_ginger_auth).
-author("Driebit <tech@driebit.nl>").

-mod_title("Authentication for Ginger").
-mod_description("Configures mod_signup and tweaks modal login").
-mod_prio(400).
-mod_depends([signup]).
-mod_schema(0).

-include_lib("zotonic.hrl").

-export([
    manage_schema/2,
    observe_signup_form_fields/3,
    event/2
]).

%% @doc Set preferred default settings (but don't overwrite if they're already set)
-spec manage_schema(install, #context{}) -> ok.
manage_schema(install, Context) ->
    PreferredConfigs = [
        {mod_signup, username_equals_email, true},
        {mod_signup, request_confirm, false}
    ],
    lists:foreach(
        fun({Mod, Key, Value}) ->
            case m_config:get(Mod, Key, Context) of 
                undefined ->
                    m_config:set_value(Mod, Key, Value, Context);
                _ ->
                    noop
            end
        end,
        PreferredConfigs
    ),
    ok.

%% @doc Persist custom fields if they are included in the signup template
-spec observe_signup_form_fields(atom(), list(), #context{}) -> list().
observe_signup_form_fields(signup_form_fields, FormProps, _Context) ->
    [{gender, false} | FormProps].

%% @doc After successful login, execute any continuation actions. If none are
%%      given, fall back to regular post-logon redirect.
event(#submit{message={logon, Args}}, Context) ->
    ContextArgs = z_context:get_q_all(Context),
    Actions = proplists:get_all_values(action, Args),
    logon(ContextArgs, Actions, Context).

logon(Args, Actions, Context) ->
    case z_notifier:first(#logon_submit{query_args=Args}, Context) of
        {ok, UserId} when is_integer(UserId) ->
            logon_user(UserId, Actions, Context);
        {error, _Reason} ->
            logon_error("pw", Context);
        undefined ->
            ?zWarning("Auth module error: #logon_submit{} returned undefined.", Context),
            logon_error("pw", Context)
    end.

logon_user(UserId, Actions, Context) ->
    case z_auth:logon(UserId, Context) of
        {ok, ContextUser} ->
            ContextRemember = case z_context:get_q("rememberme", ContextUser, []) of
                [] -> ContextUser;
                _ -> controller_logon:set_rememberme_cookie(UserId, ContextUser)
            end,
            z_render:wire(get_post_logon_action(Actions, ContextRemember), ContextRemember);
        {error, _Reason} ->
            % Could not log on, some error occured
            logon_error("unknown", Context)
    end.

logon_error(Reason, Context) ->
    Context1 = z_render:set_value("password", "", Context),
    Context2 = z_render:wire({add_class, [{target, "signup_logon_box"}, {class, "z-logon-error"}]}, Context1),
    z_render:update("logon_error", z_template:render("_logon_error.tpl", [{reason, Reason}], Context2), Context2).

%% @doc Find actions to execute after successful logon.
-spec get_post_logon_action(list(), #context{}) -> #context{}.
get_post_logon_action(Actions, Context) ->
    case Actions of
        [undefined] ->
            %% No continuation actions specified, so just do a regular redirect
            [{redirect, [{location, cleanup_url(get_ready_page(Context))}]}];
        ActionStack ->
            %% Remove topmost action: the redirect
            ActionStack
    end.

%% @doc User logged on, fetch the location of the next page to show
get_ready_page(Context) ->
    get_ready_page(z_context:get_q("page", Context, []), Context).

get_ready_page(undefined, Context) ->
    get_ready_page([], Context);
get_ready_page(Page, Context) when is_binary(Page) ->
    get_ready_page(z_convert:to_list(Page), Context);
get_ready_page(Page, Context) when is_list(Page) ->
    case z_notifier:first(#logon_ready_page{request_page=Page}, Context) of
        undefined -> Page;
        Url -> Url
    end.

cleanup_url(undefined) -> "/";
cleanup_url([]) -> "/";
cleanup_url(Url) -> z_html:noscript(Url).
