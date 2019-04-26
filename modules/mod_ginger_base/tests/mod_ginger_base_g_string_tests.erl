-module(mod_ginger_base_g_string_tests).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").

contains_test() ->
    ?assert(g_string:contains("foo", "foo")),
    ?assert(g_string:contains("foo", "barfoobaz")),
    ?assert(g_string:contains("foo", "barfoo")),
    ?assert(g_string:contains("foo", "foobar")),
    ?assert(g_string:contains("", "foo")),
    ?assert(g_string:contains("", "")),
    ?assertNot(g_string:contains("foo", "")),
    ?assertNot(g_string:contains("foo", "bar")),
    ?assertNot(g_string:contains("foo", "oof")),
    %% Done
    ok.
