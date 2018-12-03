%% @doc Execute lookups in GeoNames.
-module(geonames_lookup).

-export([
    schedule_reverse_lookup/2,
    reverse_lookup/2,
    reverse_lookup_callback/2
]).

-include_lib("zotonic.hrl").
-include_lib("../include/ginger_geonames.hrl").

%% @doc Schedule a reverse lookup.
-spec schedule_reverse_lookup(m_rsc:resource(), z:context())
        -> {ok, pos_integer()} | {error, no_geo}.
schedule_reverse_lookup(Id, Context) ->
    case geo(Id, Context) of
        undefined ->
            {error, no_geo};
        _ ->
            z_pivot_rsc:insert_task(
                ?MODULE,
                reverse_lookup_callback,
                <<"geonames-lookup-", (z_convert:to_binary(Id))/binary>>,
                [Id],
                Context
            )
    end.

%% @doc Find GeoNames places based on a resource's geo coordinates.
-spec reverse_lookup(m_rsc:resource(), z:context()) -> [map()] | {error, no_geo}.
reverse_lookup(Id, Context) ->
    case geo(Id, Context) of
        undefined ->
            {error, no_geo};
        Geo ->
            geonames_client:extended_find_nearby(Geo, Context)
    end.

%% @doc Callback for schedule_reverse_lookup/2.
%%      Look up a place name in GeoNames. If one is found, send a notification.
-spec reverse_lookup_callback(m_rsc:resource(), z:context()) -> ok | {delay, pos_integer()}.
reverse_lookup_callback(Id, Context) ->
    case geo(Id, Context) of
        undefined ->
             %% Resource has no geo coordinates any longer, so ignore.
            ok;
        Geo ->
            case geonames_client:find_nearby_place_name(Geo, Context) of
                [Place | _] ->
                    %% Location found, so notify.
                    z_notifier:notify(#geoname_found{id = Id, place = Place}, Context);
                [] ->
                    %% No locations found, so remove task from queue and return.
                    ok;
                _ ->
                    %% API unreachable or credit limits hit, so try again later.
                    {delay, 60}
            end
    end.

-spec geo(m_rsc:resource(), z:context()) -> {float(), float()} | undefined.
geo(Id, Context) ->
    geo({m_rsc:p(Id, pivot_location_lat, Context), m_rsc:p(Id, pivot_location_lng, Context)}).

geo({undefined, _Longitude}) ->
    undefined;
geo({_Latitude, undefined}) ->
    undefined;
geo(Geo) ->
    Geo.
