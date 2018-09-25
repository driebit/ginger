%% @doc Execute searches and retrieve results in JSON.
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

get_in([Key], Map) ->
    maps:get(Key, Map);
get_in([Key|Keys], Map) ->
    get_in(Keys, maps:get(Key, Map)).

to_json(Req, State) ->
    %% Init
    Context  = z_context:new(Req, ?MODULE),
    RequestArgs = wrq:req_qs(Req),
    
    %% Get search params from request
    Type = list_to_atom(proplists:get_value("type", RequestArgs, "ginger_search")),
    Offset = list_to_integer(proplists:get_value("offset", RequestArgs, "0")),
    Limit = list_to_integer(proplists:get_value("limit", RequestArgs, "1000")),
    
    %% Perform search (Zotonic offsets start at 1)
    case proplists:get_value(mode, State) of 
        coordinates ->
	    Query1 = [{source, [<<"geolocation">>]} | arguments(RequestArgs)],
	    Query2 = [{has_geo, <<"true">>} | Query1],
	    SearchResults = z_search:search({Type, Query2}, {Offset + 1, Limit}, Context),
	    Coordinates = lists:map(fun(Item) -> 
                                            Id = maps:get(<<"_id">>, Item),
                                            Location = get_in([<<"_source">>, <<"geolocation">>], Item),
                                            #{id => Id, coords => Location}
                                    end,
				    SearchResults#search_result.result),
	    Json = jiffy:encode(Coordinates),
	    {Json, Req, State};
        _ ->
	    Result = z_search:search({Type, arguments(RequestArgs)}, {Offset + 1, Limit}, Context),
	    #search_result{
	       result = Results,
	       facets = _Facets,
	       total = Total
	      } = Result,
	    %% Filter search results not visible for current user
	    VisibleResults = lists:filter(
			       fun(R) ->
				       is_visible(R, Context)
			       end,
			       Results
			      ),
	    %% Serialize to JSON
	    SearchResults = #{
			      <<"result">> => [search_result(R, Context) || R <- VisibleResults],
			      <<"total">> => Total
			     },
	    SR = json_map(fun(V) -> stringify_dates(V, Context) end, SearchResults),
	    Json = jiffy:encode(SR),
	    {Json, Req, State}
    end.


is_proplist([{K,_}]) when is_atom(K) ->
    true;
is_proplist([{K, _}|L]) when is_atom(K) ->
    is_proplist(L);
is_proplist(_) -> false.


json_map(F, Elm) when is_map(Elm) ->
    maps:fold(fun(K,V,A) -> A#{K => json_map(F, V)} end, #{}, Elm);
json_map(F, Elm) when is_list(Elm) ->
    case is_proplist(Elm) of
        true -> json_map(F, maps:from_list(Elm));
        false -> lists:map(fun(V) -> json_map(F, V) end, Elm)
    end;
json_map(F, Elm) ->
    F(Elm).

stringify_dates({{_Y, _M, _D},{_H, _Mi, _S}} = Date, Context) ->
    z_datetime:format(Date, "c", Context);
stringify_dates(V, _Context) ->
    V.

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

%% @doc Process and filter request arguments.
-spec arguments([{string(), any()}]) -> proplists:proplist().
arguments(RequestArgs) ->
    Args = [argument({list_to_existing_atom(Key), Value}) || {Key, Value} <- RequestArgs],
    whitelisted(Args).

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

%% @doc Only allow whitelisted values.
-spec whitelisted(proplists:proplist()) -> proplists:proplist().
whitelisted(Arguments) ->
    lists:filter(
      fun({Key, _Value}) ->
              lists:member(Key, whitelist())
      end,
      Arguments
     ).

%% @doc Get whitelisted search arguments.
-spec whitelist() -> [atom()].
whitelist() ->
    [cat, cat_exclude, cat_promote_recent, filter, hasobject, hassubject, text, sort, has_geo].
