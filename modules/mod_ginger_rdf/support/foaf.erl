%% @doc Export Zotonic resources to RDF in FOAF ontology.
-module(foaf).

-export([
    property_to_triples/3,
    edge_to_triples/5
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-behaviour(rdf_ontology).

property_to_triples({name_first, Value}, _Properties, _Context) ->
    [
        #triple{
            predicate = rdf_property:foaf(<<"givenName">>),
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({name_surname, _}, Properties, _Context) ->
    Surname = ginger_person:personal_name(
        Properties,
        [name_surname_prefix, name_surname]
    ),
    [
        #triple{
            predicate = rdf_property:foaf(<<"familyName">>),
            object = #rdf_value{value = Surname}
        }
    ];
property_to_triples({title, Value}, _Props, Context) ->
    m_rdf_export:translations_to_rdf(rdf_property:foaf(<<"name">>), Value, Context);
property_to_triples({_Prop, _Val}, _, _) ->
    [].

edge_to_triples(_Edge, <<?NS_FOAF, "depiction">>, Subject, Object, Context) ->
    WithMedia = m_rdf_export:with_original_media(
        Object,
        rdf_property:foaf(<<"depiction">>),
        [],
        Context
    ),
    WithThumbnail = m_rdf_export:with_thumbnail(
        Object,
        rdf_property:foaf(<<"thumbnail">>),
        WithMedia,
        Context
    );
edge_to_triples(_Edge, _Uri, _Subject, _Object, _Context) ->
    [].
