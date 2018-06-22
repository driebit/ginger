-module(mod_ginger_base_boolean_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

encode_test() ->
    ?assertEqual(true, ginger_boolean:encode(true)),
    ?assertEqual(false, ginger_boolean:encode(false)),
    ?assertError("***Unexpected value, see error message***", ginger_boolean:encode([1])),
    ?assertError("***Unexpected value, see error message***", ginger_boolean:encode(#{})),
    ?assertError("***Unexpected value, see error message***", ginger_boolean:encode(hello)),
    ?assertError("***Unexpected value, see error message***", ginger_boolean:encode(<<"Hello">>)),
    ?assertError("***Unexpected value, see error message***", ginger_boolean:encode(4.2)),
    ?assertError("***Unexpected value, see error message***", ginger_boolean:encode(42)).
