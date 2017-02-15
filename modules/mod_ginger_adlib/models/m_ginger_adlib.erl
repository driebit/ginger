%% @doc View model for displaying Adlib data in templates
-module(m_ginger_adlib).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).

m_find_value(#{} = Record, #m{value = undefined} = M, _Context) ->
    M#m{value = Record};
m_find_value(Property, #m{value = Record}, _Context) ->
    Binary = z_convert:to_binary(Property),
    #{Binary := Value} = Record,
    Value.

m_to_list(_, _Context) ->
    [].

m_value(#m{}, _Context) ->
    [].
