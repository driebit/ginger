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
    type :: resource | literal,
    subject :: binary(),
    subject_props = [] :: list(),
    predicate :: binary(),
    object :: binary(),
    object_props = [] :: list()
}).
