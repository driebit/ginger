-module(controller_mod_ginger_rest).

-export([
         init/1,
         content_types_provided/2,
         to_json/2
        ]).


-include("controller_webmachine_helper.hrl").
-include("zotonic.hrl").

init(_Config) ->
    {ok, undefined}.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, State) ->
    Context = z_context:new(Req, ?MODULE),
    %% TODO:
    %% - use `ginger_search` instead of `z_search`
    %% - incorporate access control
    %% - load and convert resources (instead of returning IDs)
    %% - process query parameters
    Resources = z_search:query_([{filter, ["is_published", true]}], Context),
    Json = jsx:encode(Resources),
    {Json, Req, State}.
