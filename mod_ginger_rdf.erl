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
    observe_rsc_get/3,
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3,
    start_link/1
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
                    ExtraProps = z_notifier:foldl(#rdf_get{uri=RscUri}, [], Context),
                    ExtraProps ++ Props
            end
    end.

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
    [m_rdf_triple:insert(Triple, Context) || Triple <- Triples],
    {noreply, State};
handle_cast(Msg, State) ->
    {stop, {unknown_cast, Msg}, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
