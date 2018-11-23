-module(controller_auth).

-export([ init/1
        , service_available/2
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
-record(state, { mode = undefined
               , context = undefined
               }
       ).

%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init([Args]) ->
    {ok, #state{mode = maps:get(mode, Args)}}.

service_available(Req, State) ->
    Context = z_context:continue_session(z_context:new(Req, ?MODULE)),
    {true, Req, State#state{context = Context}}.

allowed_methods(Req, State) ->
    {['POST', 'HEAD', 'GET'], Req, State}.

post_is_create(Req, Context) ->
    {false, Req, Context}.

process_post(Req, State = #state{mode = login}) ->
    C = State#state.context,
    {B, Req1} = wrq:req_body(Req),
    M = jsx:decode(B, [return_maps, {labels, atom}]),
    U = maps:get(username, M, undefined),
    P = maps:get(password, M, undefined),
    case m_identity:check_username_pw(U, P, C) of
        {ok, Id} ->
            case z_auth:is_enabled(Id, C) of
                true ->
                    {ok, C2} = z_session_manager:start_session(ensure, C#context.session_id, C),
                    z_context:set_session(auth_timestamp, calendar:universal_time(), C2),
                    z_context:set_session(auth_user_id, Id, C2),
                    z_context:set_session(user_id, Id, C2),
                    response(200, user(Id, C2), C2#context.wm_reqdata, C2);
                _ ->
                    response(200, user(Id, C), Req1, C)
            end;
        {error, _} ->
            response(400, <<"Error">>, Req1, C)
    end.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, State = #state{mode = login}) ->
    C = State#state.context,
    {ok, C2} = z_session_manager:continue_session(C),
    case z_session:get(auth_user_id, C2) of
        undefined ->
            response(400, <<"Error">>, Req, C);
        Id ->
            response(200, user(Id, C2), C2#context.wm_reqdata, C2)
    end;
to_json(_Req, State = #state{mode = logout}) ->
    {ok, C1} = z_session_manager:stop_session(State#state.context),
    response(200, <<>>, C1#context.wm_reqdata, C1).

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

user(Id, Context) ->
    #{ <<"identity">> => proplists:delete(propb, m_identity:get(Id, Context))
     , <<"resource">> => m_ginger_rest:rsc(Id, Context)
     }.

response(Status, Body, Req, Context) ->
    {{halt, Status}, wrq:set_resp_body(jsx:encode(Body), Req), Context}.
