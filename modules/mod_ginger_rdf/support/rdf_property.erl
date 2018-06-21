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

-spec 'dbpedia-owl'(binary()) -> ginger_uri:uri().
'dbpedia-owl'(Property) ->
    property(?NS_DBPEDIA_OWL, Property).

-spec foaf(binary()) -> ginger_uri:uri().
foaf(Property) ->
    property(?NS_FOAF, Property).

-spec geo(binary()) -> ginger_uri:uri().
geo(Property) ->
    property(?NS_GEO, Property).

-spec rdf(binary()) -> ginger_uri:uri().
rdf(Property) ->
    property(?NS_RDF, Property).

-spec rdfs(binary()) -> ginger_uri:uri().
rdfs(Property) ->
    property(?NS_RDF_SCHEMA, Property).

-spec schema(binary()) -> ginger_uri:uri().
schema(Property) ->
    property(?NS_SCHEMA_ORG, Property).

-spec vcard(binary()) -> ginger_uri:uri().
vcard(Property) ->
    property(?NS_VCARD, Property).

-spec property(binary() | string(), binary()) -> ginger_uri:uri().
property(Namespace, Property) ->
    ginger_uri:uri(<<(z_convert:to_binary(Namespace))/binary, Property/binary>>).
