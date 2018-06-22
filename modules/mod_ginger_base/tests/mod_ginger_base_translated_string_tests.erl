-module(mod_ginger_base_translated_string_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

encode_test() ->
    ?assertEqual(
       [{en, <<"Hello">>}, {nl, <<"Hallo">>}],
       ginger_translated_string:encode({trans, [{en, "Hello"}, {nl, "Hallo"}]})
      ),
    ?assertError("***Unexpected value, see error message***", ginger_translated_string:encode([1])),
    ?assertError("***Unexpected value, see error message***", ginger_translated_string:encode(#{})),
    ?assertError("***Unexpected value, see error message***", ginger_translated_string:encode(hello)),
    ?assertError("***Unexpected value, see error message***", ginger_translated_string:encode("Hello")),
    ?assertError("***Unexpected value, see error message***", ginger_translated_string:encode(<<"Hello">>)),
    ?assertError("***Unexpected value, see error message***", ginger_translated_string:encode(true)),
    ?assertError("***Unexpected value, see error message***", ginger_translated_string:encode(4.2)),
    ?assertError("***Unexpected value, see error message***", ginger_translated_string:encode(42)).
