-module(controller_login).

-export([
         init/1,
         allowed_methods/2,
         post_is_create/2,
         process_post/2
        ]).

-include("controller_webmachine_helper.hrl").
-include("zotonic.hrl").

%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init([]) ->
    {ok, undefined}.

allowed_methods(ReqData, State) ->
    {[ 'POST', 'HEAD'], ReqData, State}.

post_is_create(ReqData, Context) ->
    {false, ReqData, Context}.

process_post(ReqData, _) ->
    {B, _} =  wrq:req_body(ReqData),
    M = jsx:decode(B, [return_maps, {labels, atom}]),
    U = maps:get(username, M, undefined),
    P = maps:get(password, M, undefined),
    C = z_context:new(ReqData, ?MODULE),
    case m_identity:check_username_pw(U, P, C) of
        {ok, Id} ->
            case z_auth:is_enabled(Id, C) of
                true ->
                    {ok, C2} = z_session_manager:start_session(ensure, C#context.session_id, C),
                    RD = C2#context.wm_reqdata,
                    H = wrq:get_resp_header("Set-Cookie", RD),
                    H2 = re:replace(H, "; HttpOnly", "", [{return, list}]), % yikes!
                    ?WM_REPLY(
                       true,
                       C2#context{wm_reqdata = wrq:set_resp_header("Set-Cookie", H2, RD)}
                      );
                _ ->
                    ?WM_REPLY(true, C)
            end;
        {error, _} ->
            ?WM_REPLY(true, C)
    end.
