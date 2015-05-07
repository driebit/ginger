%% @author Driebit <tech@driebit.nl>
%% @copyright 2015

-module(mod_ginger_auth).
-author("Driebit <tech@driebit.nl>").

-mod_title("Authentication for Ginger").
-mod_description("Configures mod_signup and tweaks modal login").
-mod_prio(500).
-mod_depends([signup]).
-mod_schema(0).

-include_lib("zotonic.hrl").

-export([
    manage_schema/2
]).

%% @doc Set preferred default settings (but don't overwrite if they're already set)
-spec manage_schema(install, #context{}) -> ok.
manage_schema(install, Context) ->
    PreferredConfigs = [
        {mod_signup, username_equals_email, true},
        {mod_signup, request_confirm, false}
    ],
    lists:foreach(
        fun({Mod, Key, Value}) ->
            ?DEBUG({Mod, Key, Value}),
            case m_config:get(Mod, Key, Context) of 
                undefined ->
                    m_config:set_value(Mod, Key, Value, Context);
                _ ->
                    noop
            end
        end,
        PreferredConfigs
    ),
    ok.
