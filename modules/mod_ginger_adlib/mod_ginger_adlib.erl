%% @doc Zotonic/Adlib integration
-module(mod_ginger_adlib).
-author("Driebit <tech@driebit.nl>").

-mod_title("Adlib").
-mod_prio(500).
-mod_description("Integrates Zotonic with the Adlib API.").

-behaviour(gen_server).

-export([
    observe_search_query/2,
    pid_observe_tick_1m/3,
    pid_observe_tick_1h/3,
    pid_observe_tick_24h/3,
    endpoint/1,
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3,
    start_link/1
    , pull_updates/2, pull_updates/3]).


-include_lib("zotonic.hrl").
-include_lib("include/ginger_adlib.hrl").

-record(state, {context}).

%% @doc Search for records modified after a date
-spec pull_updates(calendar:date(), z:context()) -> ok.
pull_updates(Since, Context) ->
    pull_updates(Since, 1, Context).
pull_updates({Year, Month, Day}, StartFrom, Context) ->
    Database = <<"AMCollect">>,
    Args = [
        {search, <<"all">>},
        {database, Database},
        {modification, <<">",
            (integer_to_binary(Year))/binary,
            (integer_to_binary(Month))/binary,
            (integer_to_binary(Day))/binary>>
        }
    ],

    #search_result{result = Records} = z_search:search({adlib, Args}, {StartFrom, 20}, Context),
    [z_notifier:notify(adlib_update(Record, Database), Context) || Record <- Records].
%%    pull_updates(Since, StartFrom + 20, Context).

adlib_update(Record, Database) ->
    #adlib_update{record = Record, database = Database}.

observe_search_query(#search_query{search = {adlib, _Args}} = Query, Context) ->
    ginger_adlib_search:search(Query, Context);
observe_search_query(#search_query{}, _Context) ->
    undefined.

pid_observe_tick_1m(Pid, tick_1m, Context) ->
    pull_updates_when_needed(Pid, 60, Context).

pid_observe_tick_1h(Pid, tick_1h, Context) ->
    pull_updates_when_needed(Pid, 3600, Context).

pid_observe_tick_24h(Pid, tick_24h, Context) ->
    pull_updates_when_needed(Pid, 86400, Context).

pull_updates_when_needed(Pid, Frequency, Context) ->
    case m_config:get_value(mod_ginger_adlib, poll_frequency, Context) of
        Frequency ->
            gen_server:cast(Pid, {pull_updates, Frequency}, Context);
        _ ->
            nop
    end.

%% @doc Get Adlib API endpoint URL
-spec endpoint(z:context()) -> binary().
endpoint(Context) ->
    m_config:get_value(?MODULE, url, Context).

start_link(Args) when is_list(Args) ->
    gen_server:start_link(?MODULE, Args, []).

init(Args) ->
    {context, Context} = proplists:lookup(context, Args),
    {ok, #state{context=z_context:new(Context)}}.

handle_call(Message, _From, State) ->
    {stop, {unknown_call, Message}, State}.

handle_cast({pull_updates, _Frequency}, State = #state{context = _Context}) ->
%%    Updates = fetch_updates(Frequency, Context),
    {noreply, State};
handle_cast(Message, State) ->
    {stop, {unknown_cast, Message}, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
