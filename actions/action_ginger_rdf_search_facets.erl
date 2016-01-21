-module(action_ginger_rdf_search_facets).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-export([
    render_action/4
]).

render_action(_TriggerId, TargetId, Args, Context) ->
    Text = proplists:get_value(text, Args),
    CurrentFilters = proplists:get_value(filters, Args),
    Source = m_config:get_value(mod_ginger_rdf, source, Context),

    SearchQuery = #search_query{search = {rdf, [{text, Text}, {filters, CurrentFilters}]}},
    RdfSearch = #rdf_search{source = Source, query = SearchQuery},
    AvailableFacets = z_notifier:first(#rdf_search_facets{search = RdfSearch}, Context),

    Template = proplists:get_value(template, Args),
    Html = z_template:render(
        Template, [
            {text, proplists:get_value(text, Args)},
            {facets, AvailableFacets},
            {selected_facets, CurrentFilters}
        ],
        Context
    ),
    Context2 = z_render:update(TargetId, Html, Context),
    {[], Context2}.
