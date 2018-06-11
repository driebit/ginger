-module(controller_rest).

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
    %% - incorporate access control
    %% - load and convert resources (instead of returning IDs)
    %% - process query parameters
    Args = ginger_search:query_arguments(
             [{cat_exclude_defaults, false}, {filter, ["is_published", true]}],
             Context),
    Resources = z_search:query_(Args, Context),
    Json = jsx:encode(Resources),
    {Json, Req, State}.
