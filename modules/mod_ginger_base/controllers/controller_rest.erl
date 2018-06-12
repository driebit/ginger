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
-record(state, {mode}).


%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init(Args) ->
    Mode = proplists:get_value(mode, Args),
    {ok, #state{mode = Mode}}.

resource_exists(Req, State = #state{mode = collection}) ->
    {true, Req, State};
resource_exists(Req, State) ->
    {false, Req, State}.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, State = #state{mode = collection}) ->
    %% TODO:
    %% - incorporate access control
    %% - load and convert resources (instead of returning IDs)
    %% - process query parameters
    Context = z_context:new(Req, ?MODULE),
    Args = ginger_search:query_arguments(
             [{cat_exclude_defaults, false}, {filter, ["is_published", true]}],
             Context),
    ResourceIds= z_search:query_(Args, Context),
    Resources = lists:map(fun(Id) -> id_to_rsc(Id, Context) end, ResourceIds),
    Json = jsx:encode(Resources),
    {Json, Req, State}.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

id_to_rsc(Id, _Context) ->
    [ {id, Id}
    ].

