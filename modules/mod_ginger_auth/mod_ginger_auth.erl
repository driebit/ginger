%% @author Driebit <tech@driebit.nl>
%% @copyright 2015

-module(mod_ginger_auth).
-author("Driebit <tech@driebit.nl>").

-mod_title("Authentication for Ginger").
-mod_description("Configures mod_signup and tweaks modal login").
-mod_prio(400).
-mod_depends([mod_mqtt]).
-mod_schema(0).

-include_lib("zotonic.hrl").

-export([
    manage_schema/2,
    observe_signup_form_fields/3,
    observe_logon_actions/3
]).

%% @doc Set preferred default settings (but don't overwrite if they're already set)
-spec manage_schema(install, #context{}) -> ok.
manage_schema(install, Context) ->
    PreferredConfigs = [
        {mod_signup, username_equals_email, true},
        {mod_signup, request_confirm, true}
    ],
    lists:foreach(
        fun({Mod, Key, Value}) ->
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

%% @doc Check the action template argument for post-logon continuation actions
%% -spec observe_logon_actions(#logon_actions{}, list(), #context{}) -> undefined | list().
observe_logon_actions(#logon_actions{args=Args}, _Acc, _Context) ->
    case proplists:get_value(action, Args) of
        undefined ->
            %% return an empty action to avoid redirect
            [{script, [{script, ""}]}];
        Value ->
            Value
    end.

-spec observe_signup_form_fields(atom(), list(), #context{}) -> list().
observe_signup_form_fields(signup_form_fields, _FormProps, _Context) ->
    [
    {name_first, false},
    {name_surname, false},
    {email, true},
    {block_email, false}
    ].
