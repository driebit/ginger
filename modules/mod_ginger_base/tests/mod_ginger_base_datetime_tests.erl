-module(mod_ginger_base_datetime_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

encode_test() ->
    ?assertEqual(
       {{2018, 06, 12}, {12, 48, 08}},
       ginger_datetime:encode({{2018, 6, 12}, {12, 48, 8}})
      ),
    ?assertError("***Unexpected value, see error message***", ginger_datetime:encode([1])),
    ?assertError("***Unexpected value, see error message***", ginger_datetime:encode(#{})),
    ?assertError("***Unexpected value, see error message***", ginger_datetime:encode(hello)),
    ?assertError("***Unexpected value, see error message***", ginger_datetime:encode(true)),
    ?assertError("***Unexpected value, see error message***", ginger_datetime:encode("Hello")),
    ?assertError("***Unexpected value, see error message***", ginger_datetime:encode(<<"Hello">>)),
    ?assertError("***Unexpected value, see error message***", ginger_datetime:encode(4.2)),
    ?assertError("***Unexpected value, see error message***", ginger_datetime:encode(42)).
