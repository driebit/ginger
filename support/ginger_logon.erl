-module(ginger_logon).

-include_lib("include/zotonic.hrl").

-export([event/2]).

event(#submit{message={ginger_logon, Args}, form="logon_dialog"}, Context) ->
    LogonArgs = z_context:get_q_all(Context),
    Actions = proplists:get_all_values(action, Args),
    PageUrl = proplists:get_value(page, Args),

    case z_notifier:first(#logon_submit{query_args=LogonArgs}, Context) of
        {ok, UserId} when is_integer(UserId) ->
            logon_user(UserId, Actions, PageUrl, Context);
        {error, _Reason} -> 
            logon_error("pw", Context);
        undefined -> 
            ?zWarning("Auth module error: #logon_submit{} returned undefined.", Context),
            logon_error("unknown", Context)
    end;

event(#submit{message={ginger_signup, Args}}, Context) ->
    Actions = proplists:get_all_values(action, Args),
    PageUrl = proplists:get_value(page, Args),
    Email = z_context:get_q_validated("email", Context),
    SignupProps = [{identity, {username_pw, {Email, 
                                             z_context:get_q_validated("password1", Context)}, 
                               true, true}},
                   {identity, {email, Email, false, false}}],
    NameFull = z_context:get_q_validated("name_full", Context),
    Props = [{title, NameFull}, {name_full, NameFull}],
    RequestConfirm = z_convert:to_bool(m_config:get_value(mod_signup, request_confirm, true, Context)),
    case mod_signup:signup(Props, SignupProps, RequestConfirm, Context) of
        {ok, UserId} ->
            logon_user(UserId, Actions, PageUrl, Context);
        {error, Reason} ->  
            signup_error(Reason, Context)
    end;

event(#postback{message={ginger_logoff, Args}}, Context) ->
    controller_logoff:reset_rememberme_cookie_and_logoff(Context),
    %Id = z_convert:to_integer(proplists:get_value(id, Args)),
    PageUrl = proplists:get_value(page, Args),
    z_render:wire({redirect, [{location, PageUrl}]}, Context);

event(#submit{message={ginger_reminder, _Args}, form="ginger_password_reminder"}, Context) ->
    case z_string:trim(z_context:get_q("reminder_address", Context, [])) of
        [] ->
            logon_error("reminder", Context);
        Reminder ->
            case controller_logon:lookup_identities(Reminder, Context) of
                [] -> 
                    reminder_error("reminder", Context);
                Identities ->
                    % @todo TODO check if reminder could be sent (maybe there is no e-mail address)
                    controller_logon:send_reminder(Identities, Context),
                    z_render:growl("The Password reminder is sent to you", Context)
            end
    end.

logon_user(UserId, Actions, PageUrl, Context) ->
    case z_auth:logon(UserId, Context) of
		{ok, ContextUser} ->
		    case z_context:get_q("rememberme", ContextUser, []) of
		        [] -> ContextUser;
		        _ -> controller_logon:set_rememberme_cookie(UserId, ContextUser)
		    end,
            ?DEBUG(PageUrl),
            z_render:wire({redirect, [{location, PageUrl}]}, ContextUser);
		%{error, user_not_enabled} ->
        %    check_verified(UserId, Context);
		{error, Reason} ->
			% Could not log on, some error occured
            io:format("~p", [Reason]),
			logon_error(Reason, Context)
	end.

logon_error(Reason, Context) ->
    ?DEBUG(Reason),
    Context1 = z_render:set_value("password", "", Context),
    z_render:appear("logon_error", z_template:render("_logon_error.tpl", [{reason, Reason}], Context1), Context1).

signup_error(Reason, Context) ->
    ?DEBUG(Reason),
    z_render:appear("signup_error", z_template:render("_signup_error.tpl", [{reason, Reason}], Context), Context).

reminder_error(Reason, Context) ->
    ?DEBUG(Reason),
    z_render:appear("reminder_error", z_template:render("_signup_error.tpl", [{reason, Reason}], Context), Context).
