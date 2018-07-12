-module(mod_ginger_base_string_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

encode_test() ->
    ?assertEqual(<<"">>, ginger_string:encode("")),
    ?assertEqual(<<"">>, ginger_string:encode(<<"">>)),
    ?assertEqual(<<"Hello">>, ginger_string:encode("Hello")),
    ?assertEqual(<<"Hello">>, ginger_string:encode(<<"Hello">>)),
    ?assertError(_, ginger_string:encode([1])),
    ?assertError(_, ginger_string:encode(#{})),
    ?assertError(_, ginger_string:encode(hello)),
    ?assertError(_, ginger_string:encode(true)),
    ?assertError(_, ginger_string:encode(4.2)),
    ?assertError(_, ginger_string:encode(42)),
    %% Done
    ok.
