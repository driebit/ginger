-module(ginger_config).
-author("Driebit <tech@driebit.nl").

-export([
    install_config/1,
    install_config/2
]).

-include_lib("zotonic.hrl").

%% @doc Set preferred default config (but don't overwrite if already set)
-spec install_config(#context{}) -> ok.
install_config(Context) ->
    install_config(get_config(), Context).

install_config(Config, Context) ->
    lists:foreach(
        fun({Mod, Key, Value}) ->
            m_config:get(Mod, Key, Context),
            case m_config:get(Mod, Key, Context) of
                undefined ->
                    m_config:set_value(Mod, Key, Value, Context);
                _ ->
                    noop
            end
        end,
        Config
    ),
    ok.

%% @doc Get default Ginger config parameters
-spec get_config() -> list().
get_config() ->
    [
        {i18n, language, nl},
        {mod_l10n, timezone, <<"Europe/Berlin">>},
        {mod_l10n, timezone_is_fixed, true}
    ].
