-module(mod_ginger_base_number_tests).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").

encode_test() ->
    ?assertEqual(
       true,
       proper:quickcheck(
         ?FORALL(X, proper_types:number(), ginger_number:encode(X) =:= X)
        )
      ),
    ?assertError(_, ginger_number:encode([1])),
    ?assertError(_, ginger_number:encode(#{})),
    ?assertError(_, ginger_number:encode(hello)),
    ?assertError(_, ginger_number:encode("Hello")),
    ?assertError(_, ginger_number:encode(<<"Hello">>)),
    ?assertError(_, ginger_number:encode(true)),
    %% Done
    ok.
