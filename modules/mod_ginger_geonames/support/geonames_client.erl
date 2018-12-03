%% @doc A client for the GeoNames API.
-module(geonames_client).

-export([
    search/2,
    find_nearby_place_name/2,
    extended_find_nearby/2
]).

-type coordinates() :: {float(), float()}.

%% @doc Search GeoNames.
-spec search(proplists:proplist(), z:context()) -> list().
search(Params, Context) ->
    ParamsWithType = [{<<"type">>, <<"json">>} | Params],
    Url = url(<<"search">>, ParamsWithType, Context),
    ginger_http_client:get(Url).

%% @doc Reversely geocode a place name based on coordinates.
-spec find_nearby_place_name(coordinates(), z:context()) -> [map()].
find_nearby_place_name(Coordinates, Context) ->
    find_nearby(<<"findNearbyPlaceNameJSON">>, Coordinates, Context).

-spec extended_find_nearby(coordinates(), z:context()) -> [map()].
extended_find_nearby(Coordinates, Context) ->
    find_nearby(<<"extendedFindNearbyJSON">>, Coordinates, Context).

-spec find_nearby(binary(), coordinates(), z:context()) -> [map()].
find_nearby(Api, {Latitude, Longitude}, Context) ->
    Url = url(
        Api,
        [
            {<<"lat">>, Latitude},
            {<<"lng">>, Longitude}
        ],
        Context
    ),
    case ginger_http_client:get(Url) of
        undefined ->
            [];
        #{<<"geonames">> := Locations} ->
            Locations;
        #{<<"ocean">> := Ocean} ->
            [Ocean]
    end.

%% @doc Construct GeoNames API URL.
-spec url(binary(), proplists:proplist(), z:context()) -> ginger_uri:uri().
url(Api, Params, Context) ->
    Url = <<"http://api.geonames.org/", Api/binary>>,
    ParamsWithUsername = [{<<"username">>, mod_ginger_geonames:username(Context)} | Params],
    ginger_http_client:url_with_query_string(Url, ParamsWithUsername).
