-module(mod_ginger_geonames).
-author("Driebit <tech@driebit.nl>").

-mod_title("GeoNames").
-mod_description("Look up and place names in GeoNames").
-mod_prio(500).
-mod_depends([mod_ginger_rdf]).

-export([
    username/1
]).

-include_lib("zotonic.hrl").

%% @doc Get GeoNames username from site configuration.
-spec username(z:context()) -> binary().
username(Context) ->
    m_config:get_value(?MODULE, username, Context).
