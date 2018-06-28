%% @doc Export Zotonic resources to RDF in Schema.org ontology.
-module(schema_org).

-export([
    property_to_triples/3,
    edge_to_triples/5
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-behaviour(rdf_ontology).

property_to_triples({address_country, _}, Properties, _Context) ->
    [
        #triple{
            predicate = rdf_property:schema(<<"location">>),
            object = #rdf_resource{triples = place_to_triples(Properties)}
        }
    ];
property_to_triples({birth_city, Value}, _Properties, Context) ->
    [
        #triple{
            predicate = rdf_property:schema(<<"birthPlace">>),
            object = #rdf_value{value = z_html:strip(z_trans:trans(Value, Context))}
        }
    ];
property_to_triples({body, Value}, _Properties, Context) ->
    m_rdf_export:translations_to_rdf(rdf_property:schema(<<"description">>), Value, Context);
property_to_triples({created, Value}, _Properties, _Context) ->
    [
        #triple{
            predicate = rdf_property:schema(<<"dateCreated">>),
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({date_start, Value}, _Properties, _Context) ->
    [
        #triple{
            predicate = rdf_property:schema(<<"startDate">>),
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({date_end, Value}, _Properties, _Context) ->
    [
        #triple{
            predicate = rdf_property:schema(<<"endDate">>),
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({license, Value}, _Properties, _Context) ->
    [
        #triple{
            type = resource,
            predicate = rdf_property:schema(<<"license">>),
            object = Value
        }
    ];
property_to_triples({modified, Value}, _Properties, _Context) ->
    [
        #triple{
            predicate = rdf_property:schema(<<"dateModified">>),
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({name_first, Value}, _Properties, _Context) ->
    [
        #triple{
            predicate = rdf_property:schema(<<"givenName">>),
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
            predicate = rdf_property:schema(<<"familyName">>),
            object = #rdf_value{value = Surname}
        }
    ];
property_to_triples({phone, Value}, _Properties, _Context) ->
    [
        #triple{
            predicate = rdf_property:schema(<<"telephone">>),
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({publication_start, Value}, _Properties, _Context) ->
    [
        #triple{
            predicate = rdf_property:schema(<<"datePublished">>),
            object = #rdf_value{value = Value}
        }
    ];
property_to_triples({subtitle, Value}, _Properties, Context) ->
    m_rdf_export:translations_to_rdf(rdf_property:schema(<<"alternateName">>), Value, Context);
property_to_triples({title, Value}, _Properties, Context) ->
    m_rdf_export:translations_to_rdf(rdf_property:schema(<<"name">>), Value, Context);
property_to_triples({website, Value}, _Properties, _Context) ->
    [
        #triple{
            predicate = rdf_property:schema(<<"url">>),
            object = Value
        }
    ];
property_to_triples(_Property, _Properties, _Context) ->
    [].

edge_to_triples(_Edge, <<"http://schema.org/", _/binary>> = Uri, Subject, Object, Context) ->
    %% Return all edges with schema.org predicate URIs.
    with_title(
        [
            #triple{
                type = resource,
                predicate = Uri,
                subject = m_rsc:p(Subject, uri, Context),
                object = m_rsc:p(Object, uri, Context)
            }
        ],
        Object,
        Context
    );
edge_to_triples(_Edge, <<?NS_FOAF, "depiction">>, Subject, Object, Context) ->
    case m_rsc:p(Object, license, Context) of
        undefined ->
            %% Media is not licensed, so do not export.
            [];
        _License ->
            [
                #triple{
                    type = resource,
                    predicate = rdf_property:schema(<<"image">>),
                    subject = m_rsc:p(Subject, uri, Context),
                    object = image_object(Object, Context)
                }
            ]
    end;

edge_to_triples(_Edge, _Uri, _Subject, _Object, _Context) ->
    %% Ignore all other edges.
    [].

-spec place_to_triples(proplists:proplist()) -> [m_rdf:triple()].
place_to_triples(Properties) ->
    Latitude = proplists:get_value(pivot_location_lat, Properties),
    Longitude = proplists:get_value(pivot_location_lng, Properties),
    [
        #triple{
            predicate = rdf_property:rdf(<<"type">>),
            object = rdf_property:schema(<<"Place">>)
        }
    ] ++ address_to_triples(Properties) ++ geo_to_triples(Latitude, Longitude).

-spec address_to_triples(proplists:proplist()) -> [m_rdf:triple()].
address_to_triples(Properties) ->
    [
        #triple{
            predicate = rdf_property:schema(<<"address">>),
            object = #rdf_resource{triples = [
                #triple{
                    predicate = rdf_property:rdf(<<"type">>),
                    object = rdf_property:schema(<<"PostalAddress">>)
                },
                #triple{
                    predicate = rdf_property:schema(<<"addressLocality">>),
                    object = #rdf_value{value = proplists:get_value(address_city, Properties)}
                },
                #triple{
                    predicate = rdf_property:schema(<<"postalCode">>),
                    object = #rdf_value{value = proplists:get_value(address_postcode, Properties)}
                }
                #triple{
                    predicate = rdf_property:schema(<<"streetAddress">>),
                    object = #rdf_value{value = proplists:get_value(address_street_1, Properties)}
                },
                #triple{
                    predicate = rdf_property:schema(<<"addressCountry">>),
                    object = #rdf_value{value = proplists:get_value(address_country, Properties)}
                }
            ]}
        }
    ].

-spec geo_to_triples(float() | undefined, float() | undefined) -> [m_rdf:triple()].
geo_to_triples(Latitude, Longitude) when Latitude =/= undefined, Longitude =/= undefined ->
    [
        #triple{
            predicate = rdf_property:schema(<<"geo">>),
            object = #rdf_resource{triples = [
                #triple{
                    predicate = rdf_property:rdf(<<"type">>),
                    object = rdf_property:schema(<<"GeoCoordinates">>)
                },
                #triple{
                    predicate = rdf_property:schema(<<"latitude">>),
                    object = #rdf_value{value = Latitude}
                },
                #triple{
                    predicate = rdf_property:schema(<<"longitude">>),
                    object = #rdf_value{value = Longitude}
                }
            ]}
        }
    ];
geo_to_triples(_, _) ->
    [].

%% @doc Add literal triple with the edge's object title for convenience.
-spec with_title([m_rdf:triple()], m_rsc:resource(), z:context()) -> [m_rdf:triple()].
with_title(Triples, Object, Context) ->
    case m_rsc:p(Object, title, <<>>, Context) of
        <<>> ->
            Triples;
        Title ->
            Triples ++ [
                #triple{
                    predicate = rdf_property:schema(<<"title">>),
                    subject = m_rsc:p(Object, uri, Context),
                    object = #rdf_value{value = z_trans:trans(Title, Context)}
                }
            ]
    end.

image_object(Id, Context) ->
    Triples = [
        #triple{
            predicate = rdf_property:rdf(<<"type">>),
            object = rdf_property:schema(<<"ImageObject">>)
        },
        #triple{
            predicate = rdf_property:schema(<<"license">>),
            object = m_rsc:p(Id, license, Context)
        }
    ]
    ++ m_rdf_export:translations_to_rdf(
        rdf_property:schema(<<"name">>), m_rsc:p(Id, title, Context),
        Context
    ),
    WithMedia = m_rdf_export:with_original_media(
        Id,
        rdf_property:schema(<<"contentUrl">>),
        Triples,
        Context
    ),
    WithThumbnail = m_rdf_export:with_thumbnail(
        Id,
        rdf_property:schema(<<"thumbnail">>),
        WithMedia,
        Context
    ),
    #rdf_resource{triples = WithThumbnail}.
