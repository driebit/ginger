-module(controller_rest).

-export([
         init/1,
         resource_exists/2,
         content_types_provided/2,
         to_json/2
        ]).


-include("controller_webmachine_helper.hrl").
-include("zotonic.hrl").

%% NB: the Webmachine documenation uses "context" where we use "state",
%% we reserve "context" for the way it's used by Zotonic/Ginger.
-record(state, {context, mode}).


%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init(Args) ->
    Mode = proplists:get_value(mode, Args),
    {ok, #state{mode = Mode}}.

resource_exists(Req, State = #state{mode = colletion}) ->
    {false, Req, State#state{context = context(Req)}};
resource_exists(Req, State) ->
    {false, Req, State#state{context = context(Req)}}.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

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

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

context(Req) ->
    z_context:new(Req, ?MODULE).
