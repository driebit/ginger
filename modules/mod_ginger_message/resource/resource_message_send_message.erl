-module(resource_message_send_message).
-export([event/2]).

-include_lib("zotonic.hrl").
-include_lib("../include/message.hrl").

event({postback, {sendmessage, Props}, _TriggerId, _TargetId}, Context) ->
    Message = proplists:get_value(message, Props),
    {rsc_list, Categories} = m_rsc:o(Message, send_message, Context),

    lists:foreach(
        fun(Category) ->
            case m_rsc:is_cat(Category, category, Context) of
                true ->
                    Params = case z_notifier:first(#message_send_message{props = Props}, Context) of
                        undefined ->
                            [];
                        CustomParams ->
                            CustomParams
                    end,
                    #search_result{result = Resources} = z_search:search({'query', [{cat_exact, Category}, Params]}, {1, undefined}, Context),
                    lists:foreach(
                        fun(Item) ->
                            {ok, _Id} = m_edge:insert(Item, received_message, Message, Context)
                        end,
                        Resources
                    );
                _ ->
                    noop
            end
        end,
        Categories
    ),
    z_render:growl(?__(<<"Message sent.">>, Context), Context).
