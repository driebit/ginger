%% @doc Convenience wrapper for constructing linked data predicates.
-module(rdf_property).

-export([
    'dbpedia-owl'/1,
    foaf/1,
    rdfs/1
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

'dbpedia-owl'(Property) ->
    property(?NS_DBPEDIA_OWL, Property).

foaf(Property) ->
    property(?NS_FOAF, Property).

rdfs(Property) ->
    property(?NS_RDF_SCHEMA, Property).

property(Namespace, Property) ->
    <<(z_convert:to_binary(Namespace))/binary, Property/binary>>.
