%% @doc User message
-module(m_message).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).

m_find_value(received, #m{value = undefined}, Context) ->
    #rsc_list{list = List} = m_rsc:o(z_acl:user(Context), received_message, Context),
    List;
m_find_value(Id, #m{value = undefined} = M, _Context) ->
    M#m{value = Id};
m_find_value(is_read, #m{value = Id}, Context) ->
    case m_edge:get_id(z_acl:user(Context), read_message, Id, Context) of
        undefined -> false;
        _ -> true
    end.

m_to_list(_, _Context) ->
    [].

m_value(_Source, _Context) ->
    undefined.
