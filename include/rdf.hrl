-record(rdf_get, {uri}).

-record(rdf_search, {
    source :: binary(),
    args :: list ()
}).

-record(find_links, {id, is_a}).

-record(triple, {
    type :: resource | literal,
    subject :: binary(),
    subject_props :: list(),
    predicate :: binary(),
    object :: binary(),
    object_props :: list()
}).
