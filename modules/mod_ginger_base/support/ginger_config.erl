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
        %% Allow ginger-embed elements
        {site, html_elt_extra, <<"embed,iframe,object,script,ginger-embed">>},
        {site, html_attr_extra, <<"data,allowfullscreen,flashvars,frameborder,scrolling,async,defer,data-rdf">>},
        {mod_ginger_base, activate_impersonation, false},
        {mod_ginger_base, allow_horizontal_impersonation, false}
    ].
