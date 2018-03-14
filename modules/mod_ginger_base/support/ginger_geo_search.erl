-module(ginger_geo_search).

-export([search_query/2]).

-include_lib("zotonic.hrl").

%% @doc Supports all the usual query model arguments
%% Selects and filters locations data.
search_query(#search_query{search={ginger_geo, Args}}, Context) ->

    BaseSearch = ginger_search:search_sql(#search_query{search = {ginger_search, Args}}, Context),

    WhereStr = "rsc.pivot_location_lat IS NOT NULL AND rsc.pivot_location_lng IS NOT NULL",
    WhereSearch = and_where(BaseSearch, WhereStr),

    WhereSearch#search_sql{
        select="rsc.id, rsc.pivot_location_lat, rsc.pivot_location_lng, rsc.category_id",
        limit="Limit 5000"
    };

%% @doc Similar to z_geo_search:search_query/2 but result set includes locations and category
search_query(#search_query{search = {ginger_geo_nearby, Args}}, Context) ->
    Sql = #search_sql{select = Select} = geo_search(Args, Context),
    Sql#search_sql{
        select = Select ++ ", r.pivot_location_lat, r.pivot_location_lng, r.category_id",
        limit = "limit 5000"
    }.

%% @doc Adds a custom where argument to SQL query (using the and operator)
and_where(#search_sql{} = SearchSql, WhereStr) ->
    Where = case SearchSql#search_sql.where of
        [] ->
            [WhereStr];
        OldWhere ->
            lists:append(OldWhere, " And " ++ WhereStr)
    end,
    SearchSql#search_sql{
        where = Where
    }.

-spec geo_search(proplists:proplist(), z:context()) -> #search_sql{}.
geo_search(Args, Context) ->
    z_geo_search:search_query(#search_query{search = {geo_nearby, Args}}, Context).
