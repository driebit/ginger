-module(controller_mod_ginger_rest).

-export([
         init/1,
         content_types_provided/2,
         to_json/2
        ]).


-include("controller_webmachine_helper.hrl").
-include("zotonic.hrl").

%% NB: the Webmachine documenation uses "context" where we use "state",
%% we reserve "context" for the way it's used by Zotonic/Ginger.
-record(state, {context}).

init(Config) ->
    {ok, Config}.

content_types_provided(Req, _) ->
    Context = z_context:new(Req, ?MODULE),
    {[{"application/json", to_json}], Req, #state{context = Context}}.

to_json(Req, State = #state{context = Context}) ->
    %% TODO:
    %% - use `ginger_search` instead of `z_search`
    %% - incorporate access control
    %% - load and convert resources (instead of returning IDs)
    %% - process query parameters
    Resources = z_search:query_([{filter, ["is_published", true]}], Context),
    Json = jsx:encode(Resources),
    {Json, Req, State}.
