-module(mod_ginger_base_rest_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

%% -record(state, {mode}).

api_test() ->
    C = z_context:new(testsandboxdb),
    ok = z_module_manager:activate_await(mod_ginger_base, C),
    Sudo = z_acl:sudo(C),
    %% Create resource
    {ok, Id1} = m_rsc:insert([{category, text}, {title, <<"Title">>}], Sudo),
    %% Retrieve and decode resource
    {ok, Status1, _, _} = hackney:get(rsc_url(Id1), [], <<>>, []),
    [ ?assertEqual(200, Status1)
    ].

rsc_url(Id) ->
    Id_ = erlang:integer_to_binary(Id),
    abs_url(<<"/resources/", Id_/binary>>).

abs_url(Path) ->
    <<"http://localhost:8040/data", Path/binary>>.
