%% @doc Convenience wrapper for constructing linked data predicates.
-module(rdf_property).

-export([
    'dbpedia-owl'/1,
    dcterms/1,
    foaf/1,
    geo/1,
    rdf/1,
    rdfs/1,
    schema/1,
    vcard/1,
    acl/1,
    strip_namespace/1
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-spec 'dbpedia-owl'(binary()) -> ginger_uri:uri().
'dbpedia-owl'(Property) ->
    property(?NS_DBPEDIA_OWL, Property).

-spec dcterms(binary()) -> ginger_uri:uri().
dcterms(Property) ->
    property(?NS_DCTERMS, Property).

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

-spec acl(binary()) -> ginger_uri:uri().
acl(Property) ->
    property(?NS_ACL, Property).

-spec property(binary() | string(), binary()) -> ginger_uri:uri().
property(Namespace, Property) ->
    ginger_uri:uri(<<(z_convert:to_binary(Namespace))/binary, Property/binary>>).


-spec strip_namespace(ginger_uri:uri()) -> binary().
strip_namespace(<<?NS_DBPEDIA_OWL, Property/binary>>) ->
    <<"dbpedia-owl:", Property/binary>>;
strip_namespace(<<?NS_DCTERMS, Property/binary>>) ->
    <<"dcterms:", Property/binary>>;
strip_namespace(<<?NS_FOAF, Property/binary>>) ->
    <<"foaf:", Property/binary>>;
strip_namespace(<<?NS_GEO, Property/binary>>) ->
    <<"geo:", Property/binary>>;
strip_namespace(<<?NS_RDF, Property/binary>>) ->
    <<"rdf:", Property/binary>>;
strip_namespace(<<?NS_RDF_SCHEMA, Property/binary>>) ->
    <<"rdfs:", Property/binary>>;
strip_namespace(<<?NS_SCHEMA_ORG, Property/binary>>) ->
    <<"schema:", Property/binary>>;
strip_namespace(<<?NS_VCARD, Property/binary>>) ->
    <<"vcard:", Property/binary>>;
strip_namespace(<<?NS_ACL, Property/binary>>) ->
    <<"acl:", Property/binary>>.
