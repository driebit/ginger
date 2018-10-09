-module(controller_auth).

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

-spec init(list()) -> {ok, undefined}.
init([]) ->
    {ok, undefined}.

-spec allowed_methods(any(), any()) -> {list(), any(), any()}.
allowed_methods(ReqData, State) ->
    {['POST', 'HEAD', 'GET'], ReqData, State}.

-spec post_is_create(any(), z:context()) -> {boolean(), any(), z:context()}.
post_is_create(ReqData, Context) ->
    {false, ReqData, Context}.

-spec process_post(any(), any()) -> {{atom(), integer()}, any(), z:context()}.
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
                    z_context:set_session(auth_timestamp, calendar:universal_time(), C2),
                    z_context:set_session(auth_user_id, Id, C2),
                    z_context:set_session(user_id, Id, C2),
                    {{halt, 200}, wrq:set_resp_body(response(true, Id, C2), ReqData), C2};
                _ ->
                    {{halt, 200}, wrq:set_resp_body(response(true, Id, C), ReqData), C}
            end;
        {error, _} ->
            {{halt, 200}, wrq:set_resp_body(response(false, undefined, C), ReqData), C}
    end.

-spec response(boolean(), integer(), #context{}) -> binary().
response(Success, Id, Context) ->
    {IsVerified, User} =
        case Success of
            true ->
                {m_identity:is_verified(Id, Context), m_ginger_rest:rsc(Id, Context)};
            false ->
                {null, null}
        end,
    Response =
        #{ <<"loggedin">> => Success,
           <<"message">> => message(Success),
           <<"is_verified">> => IsVerified,
           <<"user">> => User
         },
    jsx:encode(Response).

-spec message(boolean()) -> binary().
message(false) ->
    <<"Error">>;
message(true) ->
    <<"Successfully logged in">>.
