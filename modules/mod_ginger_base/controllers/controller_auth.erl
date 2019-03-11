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
    case validate([is_password_valid(Password, Context)], undefined) of
        {ok, _} ->
            Identity = {username_pw, {Email, Password}, true, true},
            RequestConfirm = true,
            {ok, Id} = mod_signup:signup([{email, Email}], [{identity, Identity}], RequestConfirm, Context),
            ok = mod_signup:request_verification(Id, Context),
            {{halt, 204}, Req1, State};
        {error, Error} ->
            {{halt, 400}, wrq:set_resp_body(Error, Req), State}
    end;
process_post(Req, State = #state{mode = reset_password}) ->
    Context = State#state.context,
    {Body, Req1} = wrq:req_body(Req),
    #{username := Username,
      secret := Secret,
      password1 := Password1,
      password2 := Password2} = jsx:decode(Body, [return_maps, {labels, atom}]),
    Validators =
        [passwords_match(Password1, Password2),
         is_password_valid(Password1, Context),
         valid_reminder_secret(Secret, Context),
         has_username(Context)],
    case validate(Validators, undefined) of
        {ok, {UserId,  Username}} ->
            m_identity:set_username_pw(UserId, Username, Password1, z_acl:sudo(Context)),
            m_identity:delete_by_type(UserId, "logon_reminder_secret", Context),
            {{halt, 204}, Req1, State};
        {error, Error} ->
            {{halt, 400}, wrg:set_resp_body(Error, Req1), State}
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
    Validators =
        [check_username_pw(Username, Password, Context),
         login(Context)],
    case validate(Validators, undefined) of
        {ok, {Id, UserContext}} ->
            Req2 = wrq:set_resp_body(jsx:encode(user(Id, UserContext)), UserContext#context.wm_reqdata),
            {true, Req2, State};
        {error, Error} ->
            {{halt, 400}, wrq:set_resp_body(Error, Req1), State}
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



%% @doc Takes a list of unary functions that return either {error, Reason} or
%% {ok, Output} and succesively apply the functions to the output of the previous
%% function, until all funtions are evaluated, or one returns an error
validate([], Input) ->
    {ok, Input};
validate([Validator|Validators], Input) ->
    case Validator(Input) of
        {ok, Output} ->
            validate(Validators, Output);
        {error, Error} ->
            {error, Error}
    end.

%%%-----------------------------------------------------------------------------
%%% Validators
%%%-----------------------------------------------------------------------------

%% These functions are used to validate input. Each function takes some input necessary
%% for creating closures and returns a unary function that tries something. It succeeds
%% it returns {ok, Output}, which the 'validate' function above will then feed into the
%% next validator function. If it fails, the process is aborted.

%% @doc returns a validator that checks whether a password matches the regex from the config
password_matches_regex(Password, Context) ->
    case z_convert:to_list(
           m_config:get_value(mod_admin_identity, password_regex, Context)) of
        undefined ->
            %% No regex? Always okay
            fun(_) -> {ok, undefined} end;
        PasswordRegex ->
            PWString = z_convert:to_list(Password),
            fun(_) ->
                    case re:run(PWString, PasswordRegex) of
                        nomatch ->
                            {error, "Password does not match mod_admin_identity password regex"};
                        _ ->
                            {ok, undefined}
                    end
            end
    end.

%% @doc returns a validator that checks whether a password is long enough
password_has_min_length(Password, Context) ->
    PasswordMinLength = z_convert:to_integer(
                          m_config:get_value(mod_ginger_base, password_min_length, "6", Context)),
    PWString = z_convert:to_list(Password),
    fun(_) -> case length(PWString) < PasswordMinLength of
                  true ->
                      Msg = io_lib:format("Your new password is too short! The minimum password length is ~p",
                                          [PasswordMinLength]),
                      {error, Msg};
                  false ->
                      {ok, undefined}
              end
    end.

%% @doc returns a validator that checks whether a password is long enough and contains the right characters
-spec is_password_valid(binary(), z_context:context()) -> ok | {error, string()}.
is_password_valid(Password, Context) ->
    Validators =
        [password_matches_regex(Password, Context),
         password_has_min_length(Password, Context)],
    fun(_) ->
            validate(Validators, undefined)
    end.

%% @doc returns a validator that checks whether two passwords match
passwords_match(Password1, Password2) ->
    fun(_) ->
            case Password1 =:= Password2 of
                false ->
                    {error, "The two provided passwords don't match"};
                true ->
                    {ok, undefined}
            end
    end.

%% @doc returns a validator that checks whether a Secret corresponds to a user, and
%% returns the users Id if so
valid_reminder_secret(Secret, Context) ->
    fun(_) ->
            case get_by_reminder_secret(Secret, Context) of
                {ok, UserId} ->
                    {ok, UserId};
                _ ->
                    {error, "There is no matching user for the given secret."}
            end
    end.

%% @doc returns a validator that takes a userId and checks whether that user has
%% a username. It returns a tuple of {id, name} if so.
has_username(Context) ->
    fun(UserId) ->
            case m_identity:get_username(UserId, Context) of
                undefined ->
                    {error, "User does not have an username defined."};
                Username ->
                    {ok, {UserId, Username}}
            end
    end.

%% @doc returns a validator that checks whether the given username and password match,
%% and returns the user id if so.
check_username_pw(Username, Password, Context) ->
    fun(_) ->
            m_identity:check_username_pw(Username, Password, Context)
    end.

%% @doc returns a validator that takes a user id and checks whether the corresponding
%% user can log in. Returns a context with that user logged in if so.
login(Context) ->
    fun(Id) ->
            case z_auth:logon(Id, Context) of
                {ok, UserContext} ->
                    {ok, {Id, UserContext}};
                Error ->
                    Error
            end
    end.
