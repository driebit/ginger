%% @doc RDF searches through linked data
%% @author David de Boer <david@driebit.nl>
-module(ginger_rdf_search).

-export([
    search_query/2
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

%% @doc Search in linked data sources and return results as sets of RDF triples
-spec search_query(#search_query{}, list()) -> list().
search_query(#search_query{search = {rdf, _Args}, offsetlimit = _OffsetLimit} = Query, Context) ->
    %% Look up all sources and combine the results

    %% @todo Enable users to configure this config value on an admin GUI page.
    Source = m_config:get_value(mod_ginger_rdf, source, Context),
    z_notifier:first(#rdf_search{source = Source, query = Query}, Context);
search_query(#search_query{}, _Context) ->
    undefined.
