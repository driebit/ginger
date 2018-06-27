-module(m_ginger_rsc).

-export([
    translations/2
]).

-type language() :: atom().
-type translations() :: [{language(), binary()}].

%% @doc Get resource translations.
-spec translations(atom() | {trans, proplists:proplist()}, z:context()) -> translations().
translations({trans, Translations}, _Context) ->
    [{Key, z_html:unescape(Value)} || {Key, Value} <- Translations];
translations(Value, Context) ->
    [{z_trans:default_language(Context), Value}].
