%% @doc Behaviour for exporting to RDF ontologies.
-module(rdf_ontology).

-type edge() :: atom().
-type property() :: atom().
-type value() :: any().

-export_type([
    edge/0,
    property/0,
    value/0
]).

-callback property_to_triples({property(), value()}, proplists:proplist(), z:context()) -> [m_rdf:triple()].

-callback edge_to_triples(
    edge(),
    ginger_uri:uri(),
    m_rsc:resource(),
    m_rsc:resource(),
    z:context()
) -> [m_rdf:triple()].

