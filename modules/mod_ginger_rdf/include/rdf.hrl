%% @doc Common RDF vocabulary namespaces
-define(NS_RDF, "http://www.w3.org/1999/02/22-rdf-syntax-ns#").
-define(NS_RDF_SCHEMA, "http://www.w3.org/2000/01/rdf-schema#").
-define(NS_FOAF, "http://xmlns.com/foaf/0.1/").
-define(NS_GEO, "http://www.w3.org/2003/01/geo/wgs84_pos#").
-define(NS_DCTERMS, "http://purl.org/dc/terms/").
-define(NS_DCTYPE, "http://purl.org/dc/dcmitype/").
-define(NS_VCARD, "http://www.w3.org/2006/vcard/ns#").
-define(NS_DBPEDIA_OWL, "http://dbpedia.org/ontology/").
-define(NS_DBPEDIA, "http://dbpedia.org/property/").
-define(NS_SCHEMA_ORG, "http://schema.org/").

-record(rdf_get, {uri}).

-record(rdf_resource, {
    id :: binary(),
    triples = [] :: list()
}).

-record(rdf_search, {
    source :: binary(),
    args :: list (),
    query :: #search_query{}
}).

%% @doc Retrieve search facets based on search query
-record(rdf_search_facets, {
    search :: rdf_search
}).

-record(rdf_search_facet_value, {
    label = <<>> :: binary(),
    count :: integer(),
    uri :: binary(),
    value :: binary()
}).

-record(find_links, {id, is_a}).

-record(rdf_value, {
    value :: term(),
    language = undefined :: undefined | binary()
}).

-record(triple, {
    type = literal :: resource | literal,
    subject :: binary(),
    subject_props = [] :: list(),
    predicate :: binary(),
    object :: binary() | #rdf_value{},
    object_props = [] :: list()
}).

%% @doc Notification to convert a Zotonic resource to an RDF resource
-record(rsc_to_rdf, {
    id :: integer()
}).
