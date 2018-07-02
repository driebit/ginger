%% @doc Execute lookups in GeoNames.
-module(geonames_lookup).

-export([
    schedule_reverse_lookup/2,
    reverse_lookup/2
]).

-include_lib("zotonic.hrl").
-include_lib("../include/ginger_geonames.hrl").

%% @doc Schedule a reverse lookup.
-spec schedule_reverse_lookup(m_rsc:resource(), z:context())
        -> {ok, pos_integer()} | {error, no_geo}.
schedule_reverse_lookup(Id, Context) ->
    Geo = geo(Id, Context),
    case has_geo(Geo) of
        true ->
            z_pivot_rsc:insert_task(
                ?MODULE,
                reverse_lookup,
                <<"geonames-lookup-", (z_convert:to_binary(Id))/binary>>,
                [Id],
                Context
            );
        false ->
            {error, no_geo}
    end.

%% @doc Look up a place name in GeoNames. If one is found, send a notification.
-spec reverse_lookup(m_rsc:resource(), z:context()) -> ok | {delay, pos_integer()}.
reverse_lookup(Id, Context) ->
    Geo = geo(Id, Context),
    case has_geo(Geo) of
        true ->
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
            end;
        false ->
            %% Resource has no geo coordinates any longer, so ignore.
            ok
    end.

-spec geo(m_rsc:resource(), z:context()) -> {float(), float()}.
geo(Id, Context) ->
    {m_rsc:p(Id, pivot_location_lat, Context), m_rsc:p(Id, pivot_location_lng, Context)}.

-spec has_geo({float(), float()}) -> boolean().
has_geo({Lat, Long}) ->
    Lat =/= undefined andalso Long =/= undefined.
