-module(beeldenzoeker).
-author("Driebit <tech@driebit.nl>").

-mod_title("Beeldenzoeker").
-mod_description("Beeldenzoeker module om digitale collecties in te zien").
-mod_prio(50).
-mod_depends([mod_ginger_base]).
-mod_schema(1).

-include_lib("zotonic.hrl").

-export([
    manage_schema/2
]).

manage_schema(_, Context) ->
    #datamodel{}.
