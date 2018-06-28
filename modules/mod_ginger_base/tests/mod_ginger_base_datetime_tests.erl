-module(mod_ginger_base_datetime_tests).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

encode_test() ->
    ?assertEqual(
       true,
       proper:quickcheck(
         ?FORALL(
            {D, T},
            {
             {integer(1970, 2100), integer(1, 12), integer(1, 31)},
             {integer(0, 23), integer(0, 59), integer(0, 59)}
            },
            ?IMPLIES(
               calendar:valid_date(D),
               ginger_datetime:encode({D, T}) == {D, T}
              )
           )
         )
       ),
    ?assertError(_, ginger_datetime:encode([1])),
    ?assertError(_, ginger_datetime:encode(#{})),
    ?assertError(_, ginger_datetime:encode(hello)),
    ?assertError(_, ginger_datetime:encode(true)),
    ?assertError(_, ginger_datetime:encode("Hello")),
    ?assertError(_, ginger_datetime:encode(<<"Hello">>)),
    ?assertError(_, ginger_datetime:encode(4.2)),
    ?assertError(_, ginger_datetime:encode(42)),
    %% Done
    ok.
