-module(mod_ginger_base_number_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

encode_test() ->
    ?assertEqual(42, ginger_number:encode(42)),
    ?assertEqual(42.0, ginger_number:encode(42.0)),
    ?assertError("***Unexpected value, see error message***", ginger_number:encode([1])),
    ?assertError("***Unexpected value, see error message***", ginger_number:encode(#{})),
    ?assertError("***Unexpected value, see error message***", ginger_number:encode(hello)),
    ?assertError("***Unexpected value, see error message***", ginger_number:encode("Hello")),
    ?assertError("***Unexpected value, see error message***", ginger_number:encode(<<"Hello">>)),
    ?assertError("***Unexpected value, see error message***", ginger_number:encode(true)).
