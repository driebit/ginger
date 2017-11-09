%% @doc Executes search queries against the collection.
-module(collection_search).

-export([
    search/2
]).

-include_lib("zotonic.hrl").

%% @doc Supplement search arguments with facet values from the query string
%%      and parse all collection-specific search arguments.
search(#search_query{search = {_, Args}} = Query, Context) ->
    Args3 = lists:foldl(
        fun({Key, Value}, Acc) ->
            collection_query:parse_query(Key, Value, Acc)
        end,
        [],
    %%        lists:merge(Args, ?DEBUG(z_context:get_q_all_noz(Context)))
    
        z_context:get_q_all_noz(Context)
    ) ++ Args,
    
    %% Forward to Elasticsearch.
    ElasticQuery = Query#search_query{search = {elastic, Args3}},
    result(z_notifier:first(ElasticQuery, Context), Context).
    

%% @doc Handle collection search result by publishing facets (if any) to MQTT.
-spec result(Result :: undefined | #search_result{}, z:context()) -> Result :: undefined | #search_result{}.
result(undefined, _Context) ->
    undefined;
result(#search_result{facets = <<>>} = Result, _Context) ->
    Result;
result(#search_result{facets = Facets} = Result, Context) when is_map(Facets) ->
    ok = z_mqtt:publish("~session/search/facets", jsx:encode(Facets), Context),
    Result;
result(#search_result{facets = Facets} = Result, Context) ->
    ok = z_mqtt:publish("~session/search/facets", Facets, Context),
    Result.
