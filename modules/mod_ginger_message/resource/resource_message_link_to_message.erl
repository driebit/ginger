-module(resource_message_link_to_message).
-export([event/2]).

-include_lib("zotonic.hrl").

event({postback, {linkmessage, Props}, _TriggerId, _TargetId}, Context) ->
    Resource = proplists:get_value(resource, Props),
    Message = proplists:get_value(message, Props),
    EdgeExist = m_edge:get_id(Message, send_message, Resource, Context),
    case EdgeExist of
        undefined ->
            m_edge:insert(Message, send_message, Resource, Context);
        _ ->
            m_edge:delete(Message, send_message, Resource, Context)
    end,
    Context.
