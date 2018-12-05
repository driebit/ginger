-module(mod_ginger_sword).
-author("Driebit <tech@driebit.nl>").

-mod_title("SWORD support").
-mod_description("Upload resources to a SWORD endpoint").
-mod_prio(500).
-mod_depends([mod_ginger_rdf]).

-export([
         observe_rsc_update_done/2,
         dispatch_task/3,
         cancel_tasks/1
        ]).

-include_lib("zotonic.hrl").

observe_rsc_update_done(Update, Context) ->
    case z_convert:to_bool(m_config:get_value(mod_ginger_sword, publish_sword, Context)) of
        true ->
            on_rsc_update_done(Update, Context),
            ok;
        false ->
            ok
    end.

%% @doc Dispatches a task from the queue
%% If an error of some sort occurs delay the task
dispatch_task(create, RscId, Context) ->
    dispatch_task(fun create_rsc/2, RscId, Context);
dispatch_task(update, RscId, Context) ->
    dispatch_task(fun update_rsc/2, RscId, Context);
dispatch_task(delete, RscId, Context) ->
    dispatch_task(fun delete_rsc/2, RscId, Context);
dispatch_task(TaskFun, RscId, Context) when is_function(TaskFun) ->
    try
        case TaskFun(RscId, Context) of
            {error, _} ->
                {delay, 60};
            Resp ->
                case resp_is_succes(Resp) of
                    true ->
                        Resp;
                    false ->
                        {delay, 60}
                end
        end
    catch
        Error:Reason ->
            ?zWarning(io_lib:format("Sword publish failed(~p:~p):~n ~p",
                                    [Error, Reason, erlang:get_stacktrace()]),
                      Context),
            {delay, 60}
    end.

%% @doc Cancels all scheduled publication tasks
cancel_tasks(Context) ->
    z_pivot_rsc:delete_task(mod_ginger_sword, dispatch_task, Context).

sword_url(Context) ->
    z_convert:to_list(m_config:get_value(mod_ginger_sword, sword_url, Context)).

slug_prefix(Context) ->
    z_convert:to_list(m_config:get_value(mod_ginger_sword, slug_prefix, Context)).

%% Functions that format the data for transport

format_slug(RscId, Context) ->
    case slug_prefix(Context) of
        undefined ->
            z_convert:to_list(RscId);
        Prefix when is_binary(Prefix) ->
            binary_to_list(Prefix) ++ "-" ++ z_convert:to_list(RscId);
        Prefix when is_list(Prefix) ->
            Prefix ++ "-" ++ z_convert:to_list(RscId)
    end.

format_rsc_uri(RscId, Context) ->
    sword_url(Context) ++ "/" ++ format_slug(RscId, Context).

render_rdf_body(RscId, Context) ->
    AC = z_acl:sudo(Context), % We want to publish all properties even if hidden
    case m_rsc:exists(RscId, Context) of
        true ->
            RdfResource = m_rdf:to_triples(RscId, AC),
            JsonLd = ginger_json_ld:serialize(RdfResource),
            iolist_to_binary(mochijson2:encode(JsonLd));
        false ->
            <<"">>
    end.

http_request(Method, Request, _Context) ->
    Resp = httpc:request(Method, Request, [], []),
    {Status, _} = Resp,
    case Status of
        ok ->
            Resp;
        _ ->
            lager:warning("Http request failed"),
            lager:info("~p~n", [Request]),
            lager:info("~p~n", [Resp]),
            Resp
    end.

create_rsc(RscId, Context) ->
    URI = format_rsc_uri(RscId, Context),
    Body = render_rdf_body(RscId, Context),
    Slug = format_slug(RscId, Context),
    ?zInfo("Creating " ++ format_rsc_uri(RscId, Context) ++ " in SWORD endpoint", Context),
    http_request(post, {URI, [{"Slug", Slug}], "application/json", Body}, Context).

update_rsc(RscId, Context) ->
    URI = format_rsc_uri(RscId, Context),
    Body = render_rdf_body(RscId, Context),
    ?zInfo("Updating " ++ format_rsc_uri(RscId, Context) ++ " in SWORD endpoint", Context),
    http_request(put, {URI, [], "application/json", Body}, Context).

delete_rsc(RscId, Context) ->
    %% Make sure no more create and update tasks are scheduled
    z_pivot_rsc:delete_task(mod_ginger_sword, dispatch_task,
                            unique_key(create, RscId), Context),
    z_pivot_rsc:delete_task(mod_ginger_sword, dispatch_task,
                            unique_key(update, RscId), Context),

    URI = format_rsc_uri(RscId, Context),
    ?zInfo("Deleting " ++ format_rsc_uri(RscId, Context) ++ " from SWORD endpoint", Context),
    http_request(delete, {URI, []}, Context).

%% Task queueing

%% @doc Creates a unique key for referencing the task
unique_key(Task, RscId) ->
    "sword-" ++ z_convert:to_list(Task) ++ "-" ++ z_convert:to_list(RscId).

%% @doc Checks if HTTP response contains error code
resp_is_succes(Resp) ->
    {_, {{_, Code, _}, _Headers, _Body}} = Resp,
    (Code >= 200) and (Code < 300).

%% @doc Adds a new durable task to the queue
queue_task(Task, RscId, Context) ->
    %% insert_task(Module, Function, UniqueKey, Args, Context)
    z_pivot_rsc:insert_task(mod_ginger_sword,
                            dispatch_task,
                            unique_key(Task, RscId),
                            [Task, RscId],
                            Context).

%% @doc Takes a category path and determines if it must be published
cat_must_publish(IsA) ->
    ExactCat = case IsA of
                   [] ->
                       undefined;
                   _ ->
                       lists:last(IsA)
               end,
    lists:any(fun(Cat) -> ExactCat == Cat end, [story]).

%% @doc Determines if a resource state is published (to the aggregator)
state_is_published(_Props, IsA) ->
    cat_must_publish(IsA).

%% @doc Determine publication states based on the resource update notification
derive_publish_states(UpdateDone) ->
    PreProps = UpdateDone#rsc_update_done.pre_props,
    PreIsA = UpdateDone#rsc_update_done.pre_is_a,
    PostProps = UpdateDone#rsc_update_done.post_props,
    PostIsA = UpdateDone#rsc_update_done.post_is_a,
    BeforePublished = state_is_published(PreProps, PreIsA),
    AfterPublished = state_is_published(PostProps, PostIsA),
    {BeforePublished, AfterPublished}.

%% @doc Determines if the resource is being published during the update
rsc_being_published(#rsc_update_done{} = RscUpdate) ->
    case derive_publish_states(RscUpdate) of
        {false, true} ->
            true;
        _ ->
            false
    end.

%% @doc Determines if the resource is being unpublished during the update
rsc_being_unpublished(#rsc_update_done{} = RscUpdate) ->
    case derive_publish_states(RscUpdate) of
        {true, false} ->
            true;
        _ ->
            false
    end.

%% @doc Determines if the resource is being updated
rsc_being_updated(#rsc_update_done{} = RscUpdate) ->
    case derive_publish_states(RscUpdate) of
        {true, true} ->
            true;
        _ ->
            false
    end.

%% Observe resource editing

%% @doc Should be called from observer_rsc_update_done
on_rsc_update_done(#rsc_update_done{action = insert} = RscUpdate, Context) ->
    Id = RscUpdate#rsc_update_done.id,
    case rsc_being_published(RscUpdate) of
        true ->
            queue_task(create, Id, Context);
        false ->
            ok
    end;
on_rsc_update_done(#rsc_update_done{action = delete} = RscUpdate, Context) ->
    Id = RscUpdate#rsc_update_done.id,
    case rsc_being_unpublished(RscUpdate) of
        true ->
            queue_task(delete, Id, Context);
        false ->
            ok
    end;
on_rsc_update_done(#rsc_update_done{action = update} = RscUpdate, Context) ->
    Id = RscUpdate#rsc_update_done.id,
    BeingPublished = rsc_being_published(RscUpdate),
    BeingUpdated = rsc_being_updated(RscUpdate),
    BeingUnpublished = rsc_being_unpublished(RscUpdate),
    case {BeingPublished, BeingUpdated, BeingUnpublished} of
        {true, _, _ } ->
            queue_task(create, Id, Context);
        {_, true, _} ->
            queue_task(update, Id, Context);
        {_, _, true} ->
            queue_task(delete, Id, Context);
        _ ->
            ok
    end.
