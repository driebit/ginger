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

process_post(Req, #state{mode = login}) ->
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
                    {true, Req2, C2};
                _ ->
                    Req2 = wrq:set_resp_body(jsx:encode(user(Id, C)), Req1),
                    {true, Req2, C}
            end;
        {error, _} ->
            {{halt, 400}, Req1, C}
    end;
process_post(Req, #state{mode = logout}) ->
    C = z_context:new(Req, ?MODULE),
    {ok, C2} = z_session_manager:continue_session(C),
    case z_session_manager:stop_session(C2) of
        {ok, C3} ->
            {{halt, 204}, Req, C3};
        _ ->
            {{halt, 400}, Req, C2}
    end.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, #state{mode = login}) ->
    {ok, C} = z_session_manager:continue_session(z_context:new(Req, ?MODULE)),
    case z_session:get(auth_user_id, C) of
        undefined ->
            {{halt, 400}, Req, C};
        Id ->
            Req2 = wrq:set_resp_body(jsx:encode(user(Id, C)), Req),
            {true, Req2, C}
    end.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

user(Id, Context) ->
    #{ <<"identity">> => proplists:delete(propb, m_identity:get(Id, Context))
     , <<"resource">> => m_ginger_rest:rsc(Id, Context)
     }.
