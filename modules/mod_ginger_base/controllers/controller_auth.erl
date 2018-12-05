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
-record(state, { mode = undefined}).

%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init([Args]) ->
    {ok, #state{mode = maps:get(mode, Args)}}.

allowed_methods(Req, State) ->
    {['POST', 'HEAD', 'GET'], Req, State}.

post_is_create(Req, Context) ->
    {false, Req, Context}.

process_post(Req, State = #state{mode = login}) ->
    C = z_context:new(Req, ?MODULE),
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
                    Req2 = wrq:set_resp_body(jsx:encode(user(Id, C2)), C2#context.wm_reqdata),
                    {true, Req2, State};
                _ ->
                    {{halt, 400}, Req1, State}
            end;
        {error, _} ->
            {{halt, 400}, Req1, State}
    end;
process_post(Req, State = #state{mode = logout}) ->
    C = z_context:new(Req, ?MODULE),
    {ok, C2} = z_session_manager:continue_session(C),
    {ok, C3} = z_session_manager:stop_session(C2),
    {{halt, 204}, C3#context.wm_reqdata, State}.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, State = #state{mode = login}) ->
    {ok, C} = z_session_manager:continue_session(z_context:new(Req, ?MODULE)),
    case z_session:get(auth_user_id, C) of
        none ->
            {{halt, 400}, C#context.wm_reqdata, State};
        Id ->
            Body = jsx:encode(user(Id, C)),
            {Body, C#context.wm_reqdata, State}
    end.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

user(Id, Context) ->
    #{ <<"identity">> => proplists:delete(propb, m_identity:get(Id, Context))
     , <<"resource">> => m_ginger_rest:rsc(Id, Context)
     }.
