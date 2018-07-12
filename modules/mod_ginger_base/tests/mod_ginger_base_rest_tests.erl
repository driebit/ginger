-module(mod_ginger_base_rest_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

-record(state, {mode}).

resource_exists_test_() ->
    [
     fun() ->
             State = #state{mode = collection},
             {Result, _, _} =  controller_rest:resource_exists(req, State),
             ?assertEqual(true, Result)
     end,
     fun() ->
             State = #state{mode = document},
             {Result, _, _} =  controller_rest:resource_exists(req, State),
             ?assertEqual(false, Result)
     end
    ].
