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
     , <<"resource">> => m_ginger_rest:rsc(Id, Context)
     }.
