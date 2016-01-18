-module(ginger_geo_search).

-export([search_query/2]).

-include_lib("zotonic.hrl").

%% @doc Supports all the usual query model arguments
%% Selects and filters locations data.
search_query(#search_query{search={ginger_geo, Args}}, Context) ->

    BaseSearch = ginger_search:search_query(#search_query{search={ginger_search, Args}}, Context),
    
    WhereStr = "rsc.pivot_location_lat IS NOT NULL AND rsc.pivot_location_lng IS NOT NULL",
    WhereSearch = and_where(BaseSearch, WhereStr),
    
    WhereSearch#search_sql{
        select="rsc.id, rsc.pivot_location_lat, rsc.pivot_location_lng, rsc.category_id",
        limit="Limit 5000"
    };

%% @doc Similar to z_geo_search:search_query/2 but result set includes locations and category
search_query(#search_query{search={ginger_geo_nearby, Args}}, Context) ->
    
    BaseArgs = lists:filter(
        fun({Key, _}) ->
            not lists:member(Key, [distance, lat, lng])
        end,
        Args
    ),
    BaseSearch = ginger_geo_search:search_query(#search_query{search={ginger_geo, BaseArgs}}, Context),

    Distance = z_convert:to_float(proplists:get_value(distance, Args, 10)),
    {Lat, Lng} = z_geo_search:get_query_center(Args, Context),
    {LatMin, LngMin, LatMax, LngMax} = z_geo_support:get_lat_lng_bounds(Lat, Lng, Distance),
    
    WhereStr = string:join(
        [
            z_convert:to_list(LatMin),
            "< rsc.pivot_location_lat AND",
            z_convert:to_list(LngMin),
            "< rsc.pivot_location_lng AND",
            "rsc.pivot_location_lat <",
            z_convert:to_list(LatMax),
            "AND rsc.pivot_location_lng <",
            z_convert:to_list(LngMax)
        ],
        " "
    ),
    and_where(BaseSearch, WhereStr).

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
    
      