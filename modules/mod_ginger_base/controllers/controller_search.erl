%% @doc Search API controller.
-module(controller_search).

-export([
    init/1,
    content_types_provided/2,
    to_json/2
]).

-include_lib("zotonic.hrl").
-include_lib("controller_webmachine_helper.hrl").

init(Args) ->
    {ok, Args}.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, State) ->
    Context  = z_context:new(Req, ?MODULE),
    RequestArgs = wrq:req_qs(Req),

    Type = list_to_atom(proplists:get_value("type", RequestArgs, "ginger_search")),
    Offset = list_to_integer(proplists:get_value("offset", RequestArgs, "0")),
    Limit = list_to_integer(proplists:get_value("limit", RequestArgs, "1000")),

    Result = z_search:search({Type, arguments(RequestArgs)}, {Offset, Limit}, Context),
    #search_result{result = Results, facets = _Facets} = Result,

    SearchResults = #{<<"result">> => [search_result(R, Context) || R <- Results]},
    Json = jsx:encode(SearchResults),

    {Json, Req, State}.

search_result(Id, Context) when is_integer(Id) ->
    m_ginger_rsc:abstract(Id, Context);
search_result(Document, _Context) when is_map(Document) ->
    %% Return a document (such as an Elasticsearch document) as is.
    Document.

-spec arguments([{string(), any()}]) -> proplists:proplist().
arguments(RequestArgs) ->
    Args = [{list_to_existing_atom(Key), Value} || {Key, Value} <- RequestArgs],
    filter(Args).

-spec filter(proplists:proplist()) -> proplists:proplist().
filter(Arguments) ->
    lists:filter(
        fun({Key, _Value}) ->
            lists:member(Key, whitelist())
        end,
        Arguments
    ).

%% @doc Get whitelisted search arguments.
-spec whitelist() -> [atom()].
whitelist() ->
    [cat, cat_promote_recent, hasobject, hassubject, text].
