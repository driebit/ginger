-module(resource_message_send_message).
-export([event/2]).

-include_lib("zotonic.hrl").
-include_lib("include/message.hrl").

event({postback, {sendmessage, Props}, _TriggerId, _TargetId}, Context) ->
    Message = proplists:get_value(message,Props),
    {rsc_list, Categories} = m_rsc:o(Message,send_message,Context),

    lists:foreach(
        fun(Category) ->
            case m_rsc:is_cat(Category, category, Context) of
                true ->
                    CustomParameters = z_notifier:first(#message_send_message{props=Props}, Context),

                    CategoryResourcesResult = case CustomParameters of
                        undefined ->
                            z_search:search({'query', [{cat_exact, Category}]},{1,undefined},Context);
                        _ ->
                            z_search:search({'query', [{cat_exact, Category},CustomParameters]},{1,undefined},Context)
                    end,
                    CategoryResources = CategoryResourcesResult#search_result.result,
                    lists:foreach(
                        fun(Item) ->
                            m_edge:insert(Item, received_message, Message, Context)
                        end,
                        CategoryResources
                    );
                _ ->
                    noop
            end
        end,
        Categories
    ),
    Context.