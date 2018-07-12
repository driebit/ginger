-module(mod_ginger_geonames).
-author("Driebit <tech@driebit.nl>").

-mod_title("GeoNames").
-mod_description("Look up and place names in GeoNames").
-mod_prio(500).
-mod_depends([mod_ginger_rdf]).

-export([
    username/1,
    uri/1,
    schedule_geo_lookup/2
]).

-include_lib("zotonic.hrl").
-include_lib("include/ginger_geonames.hrl").

%% @doc Get GeoNames username from site configuration.
-spec username(z:context()) -> binary().
username(Context) ->
    m_config:get_value(?MODULE, username, Context).

%% @doc Construct a GeoNames URI.
-spec uri(integer()) -> binary().
uri(GeoNamesId) ->
    <<"http://sws.geonames.org/", (integer_to_binary(GeoNamesId))/binary>>.

%% @doc Schedule a task to reversely look up a place names based on the resource's coordinates.
-spec schedule_geo_lookup(m_rsc:resource(), z:context()) -> {ok, pos_integer()} | {error, no_geo}.
schedule_geo_lookup(Id, Context) ->
    geonames_lookup:schedule_reverse_lookup(Id, Context).
