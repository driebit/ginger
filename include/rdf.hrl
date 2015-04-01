-record(rdf_get, {url}).

-record(find_links, {id, is_a}).

-record(triple, {
    type      :: resource | literal,
    subject   :: binary(),
    predicate :: binary(),
    object    :: binary()
}).
