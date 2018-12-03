-module(mod_ginger_base_translated_string_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

encode_test() ->
    ?assertEqual(
       [{en, <<"Hello">>}, {nl, <<"Hallo">>}],
       ginger_translated_string:encode({trans, [{en, "Hello"}, {nl, "Hallo"}]})
      ),
    ?assertError(_, ginger_translated_string:encode([1])),
    ?assertError(_, ginger_translated_string:encode(#{})),
    ?assertError(_, ginger_translated_string:encode(hello)),
    ?assertError(_, ginger_translated_string:encode("Hello")),
    ?assertError(_, ginger_translated_string:encode(<<"Hello">>)),
    ?assertError(_, ginger_translated_string:encode(true)),
    ?assertError(_, ginger_translated_string:encode(4.2)),
    ?assertError(_, ginger_translated_string:encode(42)),
    %% Done
    ok.
