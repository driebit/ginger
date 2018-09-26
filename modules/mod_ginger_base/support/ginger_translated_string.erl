-module(ginger_translated_string).

-export([encode/1]).

-include("zotonic.hrl").

-spec encode(term()) -> list().
encode({trans, Translations}) ->
    lists:foldl(fun({Key, Value}, Acc) ->
                        Acc#{Key => z_html:unescape(Value)} end, 
                #{}, Translations);
encode(Value) ->
    ginger_type:error("ginger translation", Value).
