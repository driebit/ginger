-module(mod_ginger_collection_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").

-export([filter_iso8601/1]).

filter_iso8601_test() ->
    filter_iso8601(context()).
    
filter_iso8601(Context) ->
    ?assertEqual(<<"2010">>, filter(<<"2010">>, <<"x">>, Context)),
    ?assertEqual(<<"-2010">>, filter(<<"-2010">>, <<"x">>, Context)),
    ?assertEqual(<<"2010">>, filter(<<"2010">>, <<"d m Y">>, Context)),
    ?assertEqual(<<"2010 BCE">>, filter(<<"-2010">>, <<"d m Y">>, Context)),
    ?assertEqual(<<"01 01 2010">>, filter(<<"2010-01-01">>, <<"d m Y">>, Context)),
    ?assertEqual(<<"01 01 2010 BCE">>, filter(<<"-2010-01-01">>, <<"d m Y e">>, Context)).
    
filter(Value, Format, Context) ->
    filter_iso8601:iso8601(Value, Format, Context).

context() ->
    z_context:new(testsandboxdb).
