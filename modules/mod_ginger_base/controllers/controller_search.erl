%% @doc Execute searches and retrieve results in JSON.
-module(controller_search).

-export([ init/1
        , content_types_provided/2
        , to_json/2
        ]
       ).

-include_lib("zotonic.hrl").
-include_lib("controller_webmachine_helper.hrl").

-record(state, {mode = undefined}).

%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init(Args) ->
    Mode = proplists:get_value(mode, Args),
    {ok, #state{mode = Mode}}.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, State) ->
    Context  = z_context:new(Req, ?MODULE),
    {Type, Offset, Limit} = params(Req),
    Data =
        case State#state.mode of
            coordinates ->
                %% We're only interested in the geolocation and id field, also it doesn't make sense
                %% to retrieve results without coordinates
                Query = [{source, [<<"geolocation">>]}, {has_geo, <<"true">>} | arguments(Req)],
                Result = z_search:search({Type, Query}, {Offset + 1, Limit}, Context),
                #{ result => [coordinates(R) || R <- Result#search_result.result]
                 , total => Result#search_result.total
                 };
            _ ->
                Result = z_search:search({Type, arguments(Req)}, {Offset + 1, Limit}, Context),
                #{ result => [ search_result(R, Context)
                               || R <- Result#search_result.result , is_visible(R, Context)
                             ]
                 , total => Result#search_result.total
                 , facets => facets(Result#search_result.facets)
                 }
        end,
    {jsx:decode(Data), Req, State}.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

params(Req) ->
    RequestArgs = wrq:req_qs(Req),
    Type = list_to_atom(proplists:get_value("type", RequestArgs, "ginger_search")),
    Offset = list_to_integer(proplists:get_value("offset", RequestArgs, "0")),
    Limit = list_to_integer(proplists:get_value("limit", RequestArgs, "1000")),
    {Type, Offset, Limit}.

%% @doc Process and filter request arguments.
-spec arguments(wrq:rd()) -> proplists:proplist().
arguments(Req) ->
    RequestArgs = wrq:req_qs(Req),
    Arguments = [argument({list_to_existing_atom(Key), Value}) || {Key, Value} <- RequestArgs],
    [{Key, Value} || {Key, Value} <- Arguments, lists:member(Key, whitelist())].

%% @doc Pre-process request argument if needed.
-spec argument({atom(), list() | binary()}) -> {atom(), list() | binary()}.
argument({filter, Value}) when is_binary(Value) ->
    case binary:split(Value, <<"=">>) of
        [K, V] ->
            {filter, [K, V]};
        _ ->
            case binary:split(Value, <<"~">>) of
                [K, V] ->
                    %% Match multiple words as a phrase to get most relevant results.
                    {filter, [K, match_phrase, V]};
                _ ->
                    {filter, Value}
            end
    end;
argument({filter, Value}) ->
    argument({filter, list_to_binary(Value)});
argument(Argument) ->
    Argument.

%% @doc Get whitelisted search arguments.
-spec whitelist() -> [atom()].
whitelist() ->
    [ cat
    , cat_exclude
    , cat_promote_recent
    , content_group
    , filter
    , has_geo
    , hasobject
    , hassubject
    , sort
    , text
    ].

coordinates(SearchResult) ->
    Id = maps:get(<<"_id">>, SearchResult),
    Location = maps:get(<<"geolocation">>, maps:get(<<"_source">>, SearchResult)),
    #{ id => erlang:binary_to_integer(Id)
     , lat => maps:get(<<"lat">>, Location)
     , lng => maps:get(<<"lon">>, Location)
     }.

%% @doc Is a search result visible for the current user?
-spec is_visible(m_rsc:resource() | map(), z:context()) -> boolean().
is_visible(Id, Context) when is_integer(Id) ->
    m_rsc:is_visible(Id, Context);
is_visible(Document, _Context) when is_map(Document) ->
    %% All documents are visible.
    true.

-spec search_result(m_rsc:resource() | map(), z:context()) -> map().
search_result(Id, Context) when is_integer(Id) ->
    Rsc = m_ginger_rest:rsc(Id, Context),
    m_ginger_rest:with_edges(Rsc, [depiction], Context);
search_result(Document, _Context) when is_map(Document) ->
    %% Return a document (such as an Elasticsearch document) as is.
    Document.

%% @doc Combine separate facets (date_start_min, date_start_max) into one property
%% (date_start.min, date_start.max).
-spec facets(list() | map()) -> map().
facets([]) ->
    null;
facets(Facets) ->
    maps:fold(
        fun(K, V, Acc) ->
            Skip = byte_size(K) - 4,
            Seven = byte_size(K) - 7,
            case K of
                <<Field:Skip/binary, "_min">> ->
                    Acc#{Field => maps:put(<<"min">>, V, maps:get(Field, Acc, #{}))};
                <<Field:Skip/binary, "_max">> ->
                    Acc#{Field => maps:put(<<"max">>, V, maps:get(Field, Acc, #{}))};
                <<Field:Seven/binary, "_global">> ->
                    Min = maps:get(<<Field/binary, "_min">>, V),
                    Max = maps:get(<<Field/binary, "_max">>, V),
                    Acc#{
                        Field => maps:merge(
                            #{
                                <<"global_min">> => Min,
                                <<"global_max">> => Max
                            },
                            maps:get(Field, Acc, #{})
                        )
                    };
                _ ->
                    Acc#{K => V}
            end
        end,
        #{},
        Facets
    ).
