%% @doc User message
-module(m_message).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    read/2,
    event/2
]).

m_find_value(received, #m{value = undefined}, Context) ->
    #rsc_list{list = List} = m_rsc:o(z_acl:user(Context), received_message, Context),
    %% Show newest first
    lists:reverse(List);
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

%% @doc Mark message as read by the current user
-spec read(integer(), #context{}) -> ok.
read(Id, Context) ->
    {ok, _Id} = m_edge:insert(z_acl:user(Context), read_message, Id, Context),
    ok.

event(#postback{message = {read, _Args}}, Context) ->
    MessageId = z_context:get_q(id, Context),
    read(MessageId, Context),
    Context.
