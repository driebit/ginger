%% @doc Convenience wrapper for constructing linked data predicates.
-module(rdf_property).

-export([
    'dbpedia-owl'/1,
    foaf/1,
    geo/1,
    rdf/1,
    rdfs/1,
    schema/1,
    vcard/1
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-spec 'dbpedia-owl'(binary()) -> binary().
'dbpedia-owl'(Property) ->
    property(?NS_DBPEDIA_OWL, Property).

-spec foaf(binary()) -> binary().
foaf(Property) ->
    property(?NS_FOAF, Property).

-spec geo(binary()) -> binary().
geo(Property) ->
    property(?NS_GEO, Property).

-spec rdf(binary()) -> binary().
rdf(Property) ->
    property(?NS_RDF, Property).

-spec rdfs(binary()) -> binary().
rdfs(Property) ->
    property(?NS_RDF_SCHEMA, Property).

-spec schema(binary()) -> binary().
schema(Property) ->
    property(?NS_SCHEMA_ORG, Property).

-spec vcard(binary()) -> binary().
vcard(Property) ->
    property(?NS_VCARD, Property).

-spec property(binary() | string(), binary()) -> binary().
property(Namespace, Property) ->
    <<(z_convert:to_binary(Namespace))/binary, Property/binary>>.
