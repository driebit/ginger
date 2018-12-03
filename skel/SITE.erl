-module(%%SITE%%).
-author("Driebit <tech@driebit.nl>").

-mod_title("%%SITE%%").
-mod_description("").
-mod_prio(10).
-mod_depends([mod_ginger_base]).

%% Don't change this, but rely on schema:reset/1 instead.
-mod_schema(1).

-include_lib("zotonic.hrl").

-export([
    manage_schema/2
]).

manage_schema(_Version, Context) ->
    %%site%%_data_fixtures:load(Context).
