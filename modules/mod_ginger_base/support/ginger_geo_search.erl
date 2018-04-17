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
    BaseArgs = lists:filter(
        fun({Key, _}) ->
            not lists:member(Key, [distance, lat, lng])
        end,
        Args
    ),
    BaseSearch = search_query(#search_query{search = {ginger_geo, BaseArgs}}, Context),
    with_geo_nearby(BaseSearch, Args, Context).

%% @doc Extend an SQL query with geo nearby search based on Args.
-spec with_geo_nearby(#search_sql{}, proplists:proplist(), z:context()) -> #search_sql{}.
with_geo_nearby(#search_sql{} = SearchSql, Args, Context) ->
    GeoArgs = geo_args(Args, Context),
    {Placeholders, SearchWithGeoArgs} = add_args(GeoArgs, SearchSql),

    %% Rebuild WHERE and ORDER BY because argument positions have shifted.
    GeoWhere = arg(1, Placeholders) ++ " < pivot_location_lat AND " ++ arg(2, Placeholders) ++ "< pivot_location_lng "
            ++ " AND pivot_location_lat < " ++ arg(3, Placeholders) ++ " AND pivot_location_lng < " ++ arg(4, Placeholders),
    GeoOrder = "(pivot_location_lat-" ++ arg(5, Placeholders) ++ ")^2"
        ++ " + (pivot_location_lng-" ++ arg(6, Placeholders) ++ ")^2",
    
    %% Add geo WHERE to the Ginger search query.
    and_where(
        SearchWithGeoArgs#search_sql{order = GeoOrder},
        GeoWhere
    ).

%% @doc Get positioned argument from list of arguments.
-spec arg(pos_integer(), [string()]) -> string().
arg(Position, Args) ->
    lists:nth(Position, Args).

%% @doc Add arguments to an existing #search_sql{} query.
-spec add_args([any()], #search_sql{}) -> {[string()], #search_sql{}}.
add_args(AddArguments, #search_sql{args = Arguments} = Search) ->
    Positions = lists:map(
        fun(Index) ->
            "$" ++ integer_to_list(Index)
        end,
        lists:seq(length(Arguments) + 1, length(AddArguments) + 1)
    ),
    {Positions, Search#search_sql{args = Arguments ++ AddArguments}}.

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

%% @doc Get geo SQL arguments through geo search.
-spec geo_args(proplists:proplist(), z:context()) -> [float()].
geo_args(Args, Context) ->
    #search_sql{args = GeoArgs} = z_geo_search:search_query(
        #search_query{search = {geo_nearby, Args}},
        Context
    ),
    GeoArgs.
