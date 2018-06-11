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
-record(state, {context, mode}).

init(Args) ->
    Mode = proplists:get_value(mode, Args),
    {ok, #state{mode = Mode}}.

content_types_provided(Req, State) ->
    Context = z_context:new(Req, ?MODULE),
    {[{"application/json", to_json}], Req, State#state{context = Context}}.

to_json(Req, State = #state{context = Context, mode = collection}) ->
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
