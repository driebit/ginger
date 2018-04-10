-record(rsc_entity_text, {
    id :: term(),
    language :: atom()
}).

-record(dbpedia_spotlight_request, {
    text :: binary(),
    confidence = 0.5 :: float(),
    types = [] :: list(),
    sparql = <<>> :: binary(),
    policy :: whitelist | blacklist
}).
