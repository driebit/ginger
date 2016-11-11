-module(mod_ginger_banner).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger banner module").
-mod_description("Shows a banner on top of the site, if this is added in the config of the site or trough the rsc banner.").
-mod_prio(500).

-mod_schema(1).

-include_lib("zotonic.hrl").

-export([
    manage_schema/2
]).

manage_schema(_Version, Context) ->
    Datamodel = #datamodel{
        resources = [
            {message_banner, text, [
                {title, "Banner"},
                {is_published, false}
            ]}
        ]
    },
    z_datamodel:manage(?MODULE, Datamodel, Context).
