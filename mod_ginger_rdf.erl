%% @author Driebit <tech@driebit.nl>
%% @copyright 2015

-module(mod_ginger_rdf).
-author("Driebit <tech@driebit.nl>").

-mod_title("Ginger RDF").
-mod_description("RDF in Zotonic").
-mod_prio(500).
-mod_schema(1).

-behaviour(gen_server).

-include_lib("zotonic.hrl").
-include_lib("include/rdf.hrl").

-export([
    manage_schema/2,
    pid_observe_rsc_update_done/3,
    observe_content_types_dispatch/3,
    observe_rsc_get/3,
    observe_search_query/2,
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3,
    start_link/1,
    event/2
]).

-record(state, {context}).

manage_schema(install, Context) ->
    Datamodel = #datamodel{
        categories=[
            {rdf, meta, [{title, <<"RDF resource">>}]}
        ]
    },
    z_datamodel:manage(?MODULE, Datamodel, Context),

    %% Update some predicates so they can refer to category RDF, too
    case m_rsc:uri_lookup("http://xmlns.com/foaf/0.1/depiction", Context) of
        undefined -> noop;
        PredId ->
            Objects = m_predicate:objects(PredId, Context),
            m_predicate:update_noflush(
                PredId,
                m_predicate:subjects(PredId, Context),
                [m_rsc:rid(rdf, Context) | Objects],
                Context
            )
    end,
    ok.

%% @doc Ask observers to provide subject links from the resource and object
%%      links to the resource
pid_observe_rsc_update_done(Pid, #rsc_update_done{id=Id, post_is_a=CatList}, _Context) ->
    gen_server:cast(Pid, #find_links{id=Id, is_a=CatList}).

%% @doc When asked for properties of an RDF resource, ask the RDF data source to
%%      provide extra properties
observe_rsc_get(#rsc_get{}, [], _Context) ->
    [];
observe_rsc_get(#rsc_get{id=_Id}, Props, Context) ->

    %% Only act on non-authoritative resources
    case proplists:get_value(is_authoritative, Props) of
        true ->
            Props;
        false ->
            RscUri = proplists:get_value(uri, Props),
            case z_utils:is_empty(RscUri) of
                true ->
                    Props;
                false ->
                    z_notifier:foldl(#rdf_get{uri=RscUri}, Props, Context)
            end
    end.

observe_search_query(#search_query{} = Query, Context) ->
    ginger_rdf_search:search_query(Query, Context).

-spec observe_content_types_dispatch(#content_types_dispatch{}, list(), #context{}) -> list().
observe_content_types_dispatch(#content_types_dispatch{}, Acc, _Context) ->
    [{"application/ld+json", rsc_json_ld} | Acc].

%% @doc Find related items in linked data
-spec event(#postback_notify{}, #context{}) -> list().
event(#postback_notify{message = "feedback", trigger = "dialog-connect-find-linked-data", target = TargetId, data = _Data}, Context) ->
    Vars = [
        {text, z_context:get_q(find_text, Context)},
        {source, z_context:get_q(source, Context)},
        {template, z_context:get_q("template", Context)},
        {target, TargetId},
        {subject_id, z_convert:to_integer(z_context:get_q(subject_id, Context))},
        {predicate, z_context:get_q(predicate, Context, "")},
        {filters, lists:filtermap(fun filters/1, z_context:get_q_all_noz(Context))}
    ],

    z_render:wire(
        [
            {remove_class, [{target, TargetId}, {class, "loading"}]},
            {update, Vars}
        ],
        Context
    );
event(#postback{message = {admin_connect_select, Args}}, Context) ->
    Triple = #triple{
        subject = proplists:get_value(subject_id, Args),
        predicate = proplists:get_value(predicate, Args),
        object = z_context:get_q("object", Context),
        object_props = [
            {title, z_context:get_q("object_title", Context)}
        ]
    },
    {ok, EdgeId} = m_rdf_triple:insert(Triple, Context),

    Props = z_context:get_q("object_props", Context),
    case proplists:get_value(<<"thumbnail">>, Props) of
        undefined ->
            noop;
        Thumbnail ->
            {_S, _P, Object} = m_edge:get_triple(EdgeId, Context),

            %% Save thumbnail in Zotonic, as this seems to be the only way
            %% to show the thumbnail in the admin. Notifications such as
            %% media_stillimage only work for resources that already have a
            %% depiction and thus are not suitable for fetching depictions
            %% from outside (linked) sources.
            case m_media:depiction(Object, Context) of
                undefined ->
                    case m_media:replace_url(Thumbnail, Object, [], Context) of
                        {ok, _Medium} ->
                            noop;
                        {error, Reason} ->
                            lager:error("Could not insert medium ~p: ~p", [Thumbnail, Reason])
                    end;
                _MediumId ->
                    noop
            end
    end,
    z_render:dialog_close(Context).

start_link(Args) when is_list(Args) ->
    gen_server:start_link(?MODULE, Args, []).

init(Args) ->
    {context, Context} = proplists:lookup(context, Args),
    {ok, #state{context=z_context:new(Context)}}.

handle_call(Message, _From, State) ->
    {stop, {unknown_call, Message}, State}.

handle_cast(Record = #find_links{}, State = #state{context=Context}) ->
    %% Let other modules find outgoing links, then process them here
    Triples = z_notifier:foldr(Record, [], Context),
    AdminContext = z_acl:sudo(Context),
    [m_rdf_triple:insert(Triple, AdminContext) || Triple <- Triples],
    {noreply, State};
handle_cast(Msg, State) ->
    {stop, {unknown_cast, Msg}, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% Filter facet inputs from form inputs
filters({"filter_" ++ Key, Value}) ->
    {true, {Key, Value}};
filters({_Key, _Value}) ->
    false.
