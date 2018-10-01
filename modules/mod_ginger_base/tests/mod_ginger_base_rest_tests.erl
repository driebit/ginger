-module(mod_ginger_base_rest_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

%% -record(state, {mode}).

api_test() ->
    %% Init
    C = z_context:new(testsandboxdb),
    ok = z_module_manager:activate_await(mod_ginger_base, C),
    Sudo = z_acl:sudo(C),
    %% Create resource
    {ok, Id1} = m_rsc:insert([{category, text}, {title, <<"Title">>}, {published, true}], Sudo),
    %% Set up request and state
    Req1 = #wm_reqdata{
              path_info = dict:from_list([ {id, erlang:integer_to_list(Id1)}
                                         , {zotonic_host, testsandboxdb}
                                         ]
                                        )
             },
    {ok, State1} = controller_rest:init([{mode, document}, {path_info, id}]),
    {Result1, Req2, State2} = controller_rest:malformed_request(Req1, State1),
    {Result2, Req3, State3} = controller_rest:resource_exists(Req2, State2),
    %% Assertions
    [ ?assertEqual(false, Result1),
      ?assertEqual(true, Result2)
    ].
