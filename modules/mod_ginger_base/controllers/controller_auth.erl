-module(controller_auth).

-export([init/1
    , allowed_methods/2
    , service_available/2
    , post_is_create/2
    , process_post/2
    , content_types_provided/2
    , to_json/2
]).

-include("controller_webmachine_helper.hrl").
-include("zotonic.hrl").

%% NB: the Webmachine documentation uses "context" where we use "state",
%% we reserve "context" for the way it's used by Zotonic/Ginger.
-record(state, {mode = undefined, context :: #context{}}).

%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init([Args]) ->
    {ok, #state{mode = maps:get(mode, Args)}}.

service_available(Req, State) ->
    Context = z_context:ensure_all(z_context:new(Req, ?MODULE)),
    {true, z_context:get_reqdata(Context), State#state{context = Context}}.

allowed_methods(Req, State = #state{mode = new}) ->
    {['POST', 'HEAD'], Req, State};
allowed_methods(Req, State = #state{mode = reset}) ->
    {['POST', 'HEAD'], Req, State};
allowed_methods(Req, State = #state{mode = reset_password}) ->
    {['POST', 'HEAD'], Req, State};
allowed_methods(Req, State) ->
    {['POST', 'HEAD', 'GET'], Req, State}.

post_is_create(Req, Context) ->
    {false, Req, Context}.

process_post(Req, State = #state{mode = new}) ->
    Context = State#state.context,
    {Body, Req1} = wrq:req_body(Req),
    Data = jsx:decode(Body, [return_maps, {labels, atom}]),
    Email = maps:get(email, Data), % TODO: validate email
    Password = maps:get(password, Data),
    Identity = {username_pw, {Email, Password}, true, true},
    RequestConfirm = true,
    {ok, Id} = mod_signup:signup([{email, Email}], [{identity, Identity}], RequestConfirm, Context),
    ok = mod_signup:request_verification(Id, Context),
    {{halt, 204}, Req1, State};
process_post(Req, State = #state{mode = reset_password}) ->
    Context = State#state.context,
    {Body, Req1} = wrq:req_body(Req),
    #{username := Username,
      secret := Secret,
      password1 := Password1,
      password2 := Password2} = jsx:decode(Body, [return_maps, {labels, atom}]),
    PasswordMinLength = z_convert:to_integer(
                          m_config:get_value(mod_ginger_base, password_min_length, "6", Context)),
    %% Default to ".", which matches on any character
    PasswordRegex = m_config:get_value(mod_admin_identity, password_regex, ".", Context),
    Match = re:run(Password1, PasswordRegex),
    case {Password1,Password2, Match} of
        {A,_, _} when length(A) < PasswordMinLength ->
            Msg = io_lib:format("Your new password is too short! The minimum password length is ~p", [PasswordMinLength]),
            {{halt, 400},wrq:set_resp_body(Msg, Req), State};
        {_, _, nomatch} ->
            Msg = "Your new password does not match our password rules",
            {{halt, 400},wrq:set_resp_body(Msg, Req), State};
        {P,P, _} ->
            case get_by_reminder_secret(Secret, Context) of
                {ok, UserId} ->
                    case m_identity:get_username(UserId, Context) of
                        undefined ->
                            Msg =  "User does not have an username defined.",
                            {{halt, 500},wrq:set_resp_body(Msg, Req), State};
                        Username ->
                            m_identity:set_username_pw(UserId, Username, Password1, z_acl:sudo(Context)),
                            m_identity:delete_by_type(UserId, "logon_reminder_secret", Context),
                            {{halt, 204}, Req1, State}
                    end;
                _ ->
                    Msg = "There is no matching user for the given secret.",
                    {{halt, 400},wrq:set_resp_body(Msg, Req), State}
            end;
        {_,_, _} ->
            Msg =  "The two provided passwords don't match",
            {{halt, 400},wrq:set_resp_body(Msg, Req), State}
    end;
process_post(Req, State = #state{mode = reset}) ->
    Context = State#state.context,
    {Body, Req1} = wrq:req_body(Req),
    Data = jsx:decode(Body, [return_maps, {labels, atom}]),
    Email = maps:get(email, Data),
    controller_logon:reminder(Email, Context),
    {{halt, 204}, Req1, State};
process_post(Req, State = #state{mode = login}) ->
    {Body, Req1} = wrq:req_body(Req),
    Data = jsx:decode(Body, [return_maps, {labels, atom}]),
    Username = maps:get(username, Data, undefined),
    Password = maps:get(password, Data, undefined),
    Context = State#state.context,
    case m_identity:check_username_pw(Username, Password, Context) of
        {ok, Id} ->
            case z_auth:logon(Id, Context) of
                {ok, UserContext} ->
                    Req2 = wrq:set_resp_body(jsx:encode(user(Id, UserContext)), UserContext#context.wm_reqdata),
                    {true, Req2, State};
                _ ->
                    {{halt, 400}, Req1, State}
            end;
        {error, _} ->
            {{halt, 400}, Req1, State}
    end;
process_post(_Req, State = #state{mode = logout}) ->
    Context = controller_logoff:reset_rememberme_cookie_and_logoff(State#state.context),
    {{halt, 204}, Context#context.wm_reqdata, State}.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(_Req, State = #state{mode = status}) ->
    Context = State#state.context,
    case z_acl:user(Context) of
        undefined ->
            {{halt, 400}, Context#context.wm_reqdata, State};
        Id ->
            Body = jsx:encode(user(Id, Context)),
            {Body, Context#context.wm_reqdata, State}
    end.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

user(Id, Context) ->
    Identity =
        % m_identity:get_rsc fetches the identity details linked to the rsc id
        case m_identity:get_rsc_by_type(Id, username_pw, Context) of
            [FirstIdentity|_Rest] -> proplists:delete(propb, FirstIdentity);
            _ -> null
        end,
    #{ <<"identity">> => Identity
     , <<"resource">> => m_ginger_rest:with_edges(m_ginger_rest:rsc(Id, Context), Context)
     }.

get_by_reminder_secret(Code, Context) ->
    case m_identity:lookup_by_type_and_key("logon_reminder_secret", Code, Context) of
        undefined -> undefined;
        Row -> {ok, proplists:get_value(rsc_id, Row)}
    end.
