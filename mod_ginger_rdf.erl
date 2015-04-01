%% @author Driebit <tech@driebit.nl>
%% @copyright 2015

-module(mod_ginger_rdf).
-author("Driebit <tech@driebit.nl>").

-mod_title("Ginger RDF").
-mod_description("RDF in Zotonic").
-mod_prio(500).

-behaviour(gen_server).

-include_lib("zotonic.hrl").
-include_lib("include/rdf.hrl").

-export([
    pid_observe_rsc_pivot_done/3,
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3,
    start_link/1
]).

-record(state, {context}).

%% @doc When pivot is done, ask observers to provide subject links from the 
%% resource and object links to the resource.
pid_observe_rsc_pivot_done(Pid, #rsc_pivot_done{id=Id, is_a=CatList}, Context) ->
    gen_server:cast(Pid, #find_links{id=Id, is_a=CatList}).

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
    
    %% todo: store the triples
    ?DEBUG(Triples),
    {noreply, State};
handle_cast(Msg, State) ->
    {stop, {unknown_cast, Msg}, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
