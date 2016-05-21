%% @doc Common RDF vocabulary namespaces
-define(NS_RDF, "http://www.w3.org/1999/02/22-rdf-syntax-ns#").
-define(NS_FOAF, "http://xmlns.com/foaf/0.1/").
-define(NS_GEO, "http://www.w3.org/2003/01/geo/wgs84_pos#").
-define(NS_DCTERMS, "http://purl.org/dc/terms/").
-define(NS_DCTYPE, "http://purl.org/dc/dcmitype/").
-define(NS_VCARD, "http://www.w3.org/2006/vcard/ns#").

-record(rdf_get, {uri}).

-record(rdf_resource, {
    id :: binary(),
    triples :: list()
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

-record(triple, {
    type = literal :: resource | literal,
    subject :: binary(),
    subject_props = [] :: list(),
    predicate :: binary(),
    object :: binary(),
    object_props = [] :: list()
}).

%% @doc Notification to convert a Zotonic resource to an RDF resource
-record(rsc_to_rdf, {
    id :: integer()
}).
