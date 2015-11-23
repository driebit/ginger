%% @doc Export resources
-module(ginger_export_rsc).
-author("Driebit <tech@driebit.nl>").

-export([
    get_headers/0,
    get_properties/0,
    export/2
]).

-include_lib("zotonic.hrl").

%% @doc Get human-readable CSV headers that will be appended to exported CSV
-spec get_headers() -> list().
get_headers() ->
    [id, name, category, title, short_title, summary, body, latitude, longitude, created, modified, url].

%% @doc Get Zotonic property names that will be exported
-spec get_properties() -> list().
get_properties() ->
    [id, name, category, title, short_title, summary, body, location_lat, location_lng, created, modified, page_url_abs].

%% @doc Export a single resource
-spec export(integer(), #context{}) -> list().
export(Id, Context) ->
    [ get_value(Id, Property, Context) || Property <- get_properties() ].

%% @doc Get single property value
get_value(Id, category, Context) ->
    m_rsc:p(m_rsc:p(Id, category_id, Context), name, Context);
get_value(Id, Property, Context) ->
    m_rsc:p(Id, Property, Context).
