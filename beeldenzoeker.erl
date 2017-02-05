-module(beeldenzoeker).
-author("Driebit <tech@driebit.nl>").

-mod_title("Beeldenzoeker").
-mod_description("Collectie doorzoeker voor de collectie van Hart Amsterdam").
-mod_prio(10).
-mod_depends([mod_ginger_base]).
-mod_schema(1).

-include_lib("zotonic.hrl").

-export([
    manage_schema/2
]).

manage_schema(_, Context) ->
    #datamodel{}.
