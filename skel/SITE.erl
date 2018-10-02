-module(%%SITE%%).
-author("Driebit <tech@driebit.nl>").

-mod_title("%%SITE%%").
-mod_description("").
-mod_prio(10).
-mod_depends([mod_ginger_base]).
-mod_schema(1).

-include_lib("zotonic.hrl").

-export([
    manage_schema/2
]).

manage_schema(_Type, Context) ->
    %%site%%_data_fixtures:load(Context).
