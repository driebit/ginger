-module(mod_ginger_base_string_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").


encode_test() ->
    ?assertEqual(<<"">>, ginger_string:encode("")),
    ?assertEqual(<<"Hello">>, ginger_string:encode("Hello")),
    ?assertEqual(<<"ABC">>, ginger_string:encode([65, 66, 67])),
    ?assertEqual(<<"">>, ginger_string:encode([])),
    %% ?assertEqual(<<"Hello">>, ginger_string:encode(<<"Hello">>)), <- Should succeed ?
    ?assertError("***Unexpected value, see error message***", ginger_string:encode([1])),
    ?assertError("***Unexpected value, see error message***", ginger_string:encode(#{})),
    ?assertError("***Unexpected value, see error message***", ginger_string:encode(hello)),
    ?assertError("***Unexpected value, see error message***", ginger_string:encode(true)),
    ?assertError("***Unexpected value, see error message***", ginger_string:encode(4.2)),
    ?assertError("***Unexpected value, see error message***", ginger_string:encode(42)).
