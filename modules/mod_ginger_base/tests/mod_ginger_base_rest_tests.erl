-module(mod_ginger_base_rest_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

-record(state, {mode}).

resource_exists_test() ->
    State = #state{mode = collection},
    {Result, _, _} =  controller_rest:resource_exists(req, State),
    ?assertEqual(true, Result),
    ok.
