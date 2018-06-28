%% @doc Export Zotonic resources to RDF in Schema.org ontology.
-module(dcterms).

-export([
    property_to_triples/3,
    edge_to_triples/5
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-behaviour(rdf_ontology).

property_to_triples({body, Value}, _Props, Context) ->
    m_rdf_export:translations_to_rdf(rdf_property:dcterms(<<"description">>), Value, Context);
property_to_triples({created, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = rdf_property:dcterms(<<"created">> ),
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({date_start, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = rdf_property:dcterms(<<"date">>),
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({modified, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = rdf_property:dcterms(<<"modified">>),
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({publication_start, Value}, _Props, _Context) ->
    [
        #triple{
            predicate = rdf_property:dcterms(<<"issued">>),
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({license, Value}, _Props, _Context) ->
    [
        #triple{
            type = resource,
            predicate = rdf_property:dcterms(<<"license">>),
            object = Value
        }
    ];
property_to_triples({subtitle, Value}, _Props, Context) ->
    m_rdf_export:translations_to_rdf(rdf_property:dcterms(<<"alternative">>), Value, Context);
property_to_triples({summary, Value}, _Props, Context) ->
    m_rdf_export:translations_to_rdf(rdf_property:dcterms(<<"abstract">>), Value, Context);
property_to_triples({title, Value}, _Props, Context) ->
    m_rdf_export:translations_to_rdf(rdf_property:dcterms(<<"title">>), Value, Context);
property_to_triples({_Prop, _Val}, _, _) ->
    [].

edge_to_triples(_Edge, _Uri, _Subject, _Object, _Context) ->
    [].
