-module(ginger_translated_string).

-export([encode/1]).

-include("zotonic.hrl").

-spec encode(term()) -> list().
encode({trans, Translations}) ->
    [{Key, z_html:unescape(Value)} || {Key, Value} <- Translations];
encode(Value) ->
    ginger_type:error("ginger translation", Value).
