%% @doc View model for displaying Adlib data in templates
-module(m_zzc_adlib).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    event/2
]).

m_find_value(listdatabases, #m{value = undefined}, Context) ->
    [maps:to_list(Map) || Map <- zzc_adlib_client:listdatabases(Context)];
m_find_value(Property, #m{value = Record}, _Context) ->
    Binary = z_convert:to_binary(Property),
    #{Binary := Value} = Record,
    Value.

m_to_list(_, _Context) ->
    [].

m_value(#m{}, _Context) ->
    [].

%% @doc Enable/disable an Adlib database for polling
event(#postback{message = {toggle_database, Args}}, Context) ->
    Database = proplists:get_value(database, Args),

    case z_acl:is_allowed(use, mod_zzc_adlib, Context) of
        true ->
            Current = mod_zzc_adlib:enabled_databases(Context),
            NewList = case z_convert:to_bool(z_context:get_q("triggervalue", Context)) of
                false ->
                    lists:delete(Database, Current);
                true ->
                    [Database | Current]
            end,
            m_config:set_prop(mod_zzc_adlib, databases, list, NewList, Context),
            Context;
        false ->
            Context
    end.
