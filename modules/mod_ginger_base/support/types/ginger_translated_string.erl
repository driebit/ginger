-module(ginger_translated_string).

-export([encode/1]).

-include("zotonic.hrl").

-spec encode(term()) -> number().
encode({trans, Translations}) ->
    [{Key, z_html:unescape(Value)} || {Key, Value} <- Translations];
encode(Value) ->
    erlang:error(<<"Expecting a translated string">>, Value).
