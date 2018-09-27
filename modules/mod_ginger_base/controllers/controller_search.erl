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

to_json(Req, State) ->
    %% Init
    Context  = z_context:new(Req, ?MODULE),
    RequestArgs = wrq:req_qs(Req),
    
    %% Get search params from request
    Type = list_to_atom(proplists:get_value("type", RequestArgs, "ginger_search")),
    Offset = list_to_integer(proplists:get_value("offset", RequestArgs, "0")),
    Limit = list_to_integer(proplists:get_value("limit", RequestArgs, "1000")),
    
    case proplists:get_value(mode, State) of 
        coordinates ->
            %% We're only interested in the geolocation and id fields
	    Query1 = [{source, [<<"geolocation">>]} | arguments(RequestArgs)],
            %% And it doesn't make sense to retrieve any results without coordinates
	    Query2 = [{has_geo, <<"true">>} | Query1],
            %% Perform search (Zotonic offsets start at 1)
	    SearchResults = z_search:search({Type, Query2}, {Offset + 1, Limit}, Context),
            %% Strip any unneeded data
	    Coordinates = 
                lists:map(
                  fun(Item) -> 
                          #{<<"_id">> := Id,
                            <<"_source">> :=
                                #{<<"geolocation">> := 
                                      #{<<"lat">> := Lat,
                                        <<"lon">> := Lon
                                       }
                                 }
                           } = Item,
                          #{id => list_to_integer(binary_to_list(Id)),
                            lat => Lat, lng => Lon}
                  end,
                  SearchResults#search_result.result),
            Result = #{<<"result">> => Coordinates,
                       <<"total">> => SearchResults#search_result.total},
	    Json = jiffy:encode(Result),
	    {Json, Req, State};
        _ ->
            %% Perform search (Zotonic offsets start at 1)
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
	    Json = jsx:encode(SearchResults),
	    {Json, Req, State}
    end.

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
