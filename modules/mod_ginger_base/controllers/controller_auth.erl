-module(controller_auth).

-export([ init/1
        , allowed_methods/2
        , post_is_create/2
        , process_post/2
        , content_types_provided/2
        , to_json/2
        ]
       ).

-include("controller_webmachine_helper.hrl").
-include("zotonic.hrl").

%% NB: the Webmachine documentation uses "context" where we use "state",
%% we reserve "context" for the way it's used by Zotonic/Ginger.
-record(state, {mode = undefined}).

%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init([Args]) ->
    {ok, #state{mode = maps:get(mode, Args)}}.

allowed_methods(Req, State = #state{mode = new}) ->
    {['POST', 'HEAD'], Req, State};
allowed_methods(Req, State = #state{mode = reset}) ->
    {['POST', 'HEAD'], Req, State};
allowed_methods(Req, State) ->
    {['POST', 'HEAD', 'GET'], Req, State}.

post_is_create(Req, Context) ->
    {false, Req, Context}.

process_post(Req, State = #state{mode = new}) ->
    Context = z_context:new(Req, ?MODULE),
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
    Context = z_context:new(Req, ?MODULE),
    {Body, Req1} = wrq:req_body(Req),
    Data = jsx:decode(Body, [return_maps, {labels, atom}]),
    Email = maps:get(email, Data),
    controller_logon:reminder(Email, Context),
    {{halt, 204}, Req1, State};
process_post(Req, State = #state{mode = login}) ->
    Context = z_context:new(Req, ?MODULE),
    {Body, Req1} = wrq:req_body(Req),
    Data = jsx:decode(Body, [return_maps, {labels, atom}]),
    Username = maps:get(username, Data, undefined),
    Password = maps:get(password, Data, undefined),
    case m_identity:check_username_pw(Username, Password, Context) of
        {ok, Id} ->
            case z_auth:is_enabled(Id, Context) of
                true ->
                    {ok, Context2} =
                        z_session_manager:start_session(ensure, Context#context.session_id, Context),
                    z_context:set_session(auth_timestamp, calendar:universal_time(), Context2),
                    z_context:set_session(auth_user_id, Id, Context2),
                    z_context:set_session(user_id, Id, Context2),
                    Req2 = wrq:set_resp_body(jsx:encode(user(Id, Context2)), Context2#context.wm_reqdata),
                    {true, Req2, State};
                _ ->
                    {{halt, 400}, Req1, State}
            end;
        {error, _} ->
            {{halt, 400}, Req1, State}
    end;
process_post(Req, State = #state{mode = logout}) ->
    Context = z_context:new(Req, ?MODULE),
    {ok, Context2} = z_session_manager:continue_session(Context),
    {ok, Context3} = z_session_manager:stop_session(Context2),
    {{halt, 204}, Context3#context.wm_reqdata, State}.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, State = #state{mode = status}) ->
    {ok, Context} = z_session_manager:continue_session(z_context:new(Req, ?MODULE)),
    case z_session:get(user_id, Context) of
        none ->
            {{halt, 400}, Context#context.wm_reqdata, State};
        Id ->
            Body = jsx:encode(user(Id, Context)),
            {Body, Context#context.wm_reqdata, State}
    end.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

user(Id, Context) ->
    #{ <<"identity">> => proplists:delete(propb, m_identity:get(Id, Context))
     , <<"resource">> => m_ginger_rest:rsc(Id, Context)
     }.
