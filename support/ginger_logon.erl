-module(ginger_logon).

-include_lib("include/zotonic.hrl").

-export([event/2]).

event(#submit{message={ginger_logon, Args}, form="logon_dialog"}, Context) ->
    LogonArgs = z_context:get_q_all(Context),
    Actions = proplists:get_all_values(action, Args),
    case z_notifier:first(#logon_submit{query_args=LogonArgs}, Context) of
        {ok, UserId} when is_integer(UserId) ->
            ContextUser = logon_user(UserId, Actions, Context);
            % PageUrl = z_convert:to_integer(proplists:get_value("page", Args)),
            % z_render:wire({redirect, [{location, PageUrl}]}, ContextUser);
        {error, _Reason} ->
            z_render:wire({show, [{target, "logon_error"}]}, Context);
        undefined ->
            ?zWarning("Auth module error: #logon_submit{} returned undefined.", Context),
            z_render:growl_error("Configuration error: please enable a module for #logon_submit{}", Context)
    end;

event(#postback{message={ginger_logoff, Args}}, Context) ->
    controller_logoff:reset_rememberme_cookie_and_logoff(Context),
    Id = z_convert:to_integer(proplists:get_value("id", Args)),
    PageUrl = m_rsc:p(Id, page_url, Context),
    z_render:wire({redirect, [{location, PageUrl}]}, Context).

logon_user(UserId, Actions, Context) ->
    case z_auth:logon(UserId, Context) of
		{ok, ContextUser} ->
		    ContextRemember = case z_context:get_q("rememberme", ContextUser, []) of
		        [] -> ContextUser;
		        _ -> controller_logon:set_rememberme_cookie(UserId, ContextUser)
		    end,
            z_render:wire([
                {replace, [{target, "nav-logon"}, {template, "_nav_logon.tpl"}]} | Actions],
                ContextRemember);
		%{error, user_not_enabled} ->
        %    check_verified(UserId, Context);
		{error, _Reason} ->
			% Could not log on, some error occured
			logon_error("unknown", Context)
	end.

logon_error(Reason, Context) ->
    Context1 = z_render:set_value("password", "", Context),
    Context2 = z_render:wire({add_class, [{target, "logon_box"}, {class, "logon_error"}]}, Context1),
    z_render:update("logon_error", z_template:render("_logon_error.tpl", [{reason, Reason}], Context2), Context2).
