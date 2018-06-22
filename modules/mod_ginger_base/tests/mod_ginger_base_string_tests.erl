-module(mod_ginger_base_string_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").


encode_test_() ->
    [
     fun() ->
             Result = ginger_string:encode("Hello"),
             ?assertEqual(<<"Hello">>, Result)
     end
    ].
