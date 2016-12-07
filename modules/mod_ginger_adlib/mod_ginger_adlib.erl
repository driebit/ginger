%% @doc Zotonic/Adlib integration
-module(mod_ginger_adlib).
-author("Driebit <tech@driebit.nl>").

-mod_title("Adlib").
-mod_prio(500).
-mod_description("Integrates Zotonic with the Adlib API.").

-export([
    observe_search_query/2,
    endpoint/1
]).

-include("zotonic.hrl").

observe_search_query(#search_query{search = {adlib, _Args}} = Query, Context) ->
    ginger_adlib_search:search(Query, Context);
observe_search_query(#search_query{}, _Context) ->
    undefined.

%% @doc Get Adlib API endpoint URL
-spec endpoint(z:context()) -> binary().
endpoint(Context) ->
    m_config:get_value(?MODULE, url, Context).
