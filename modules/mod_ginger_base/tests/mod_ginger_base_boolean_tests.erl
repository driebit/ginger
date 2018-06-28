-module(mod_ginger_base_boolean_tests).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

encode_test() ->
    ?assertEqual(
       true,
       proper:quickcheck(
         ?FORALL(X, proper_types:boolean(), ginger_boolean:encode(X) == X)
        )
      ),
    ?assertError(_, ginger_boolean:encode([1])),
    ?assertError(_, ginger_boolean:encode(#{})),
    ?assertError(_, ginger_boolean:encode(hello)),
    ?assertError(_, ginger_boolean:encode("Hello")),
    ?assertError(_, ginger_boolean:encode(<<"Hello">>)),
    ?assertError(_, ginger_boolean:encode(4.2)),
    ?assertError(_, ginger_boolean:encode(42)),
    %% Done
    ok.
