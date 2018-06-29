-module(mod_ginger_rdf_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").
-include("../include/rdf.hrl").

serialize_to_map_test() ->
    Resource = #rdf_resource{
        id = <<"http://dinges.com/123">>,
        triples = [
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"dcterms:abstract">>,
                object = #rdf_value{value = <<"Good story bro!">>}
            },
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"owl:sameAs">>,
                object = <<"http://nl.dbpedia.org/resource/Dinges">>
            },
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"dcterms:creator">>,
                object = <<"http://dinges.com/456">>
            },
            #triple{
                subject = <<"http://dinges.com/456">>,
                predicate = <<"rdfs:label">>,
                object = #rdf_value{value = <<"Pietje Puk">>}
            }
        ]
    },
    Map = ginger_json_ld:serialize_to_map(Resource),
    Expected = #{
        <<"@id">> => <<"http://dinges.com/123">>,
        <<"dcterms:abstract">> => #{<<"@value">> => <<"Good story bro!">>},
        <<"dcterms:creator">> => #{
            <<"@id">> => <<"http://dinges.com/456">>,
            <<"rdfs:label">> => #{<<"@value">> => <<"Pietje Puk">>}
        },
        <<"owl:sameAs">> => #{<<"@id">> => <<"http://nl.dbpedia.org/resource/Dinges">>}
    },
    ?assertEqual(Expected, Map).

serialize_multiple_levels_to_map_test() ->
    Resource = #rdf_resource{
        id = <<"http://dinges.com/123">>,
        triples = [
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"dcterms:abstract">>,
                object = #rdf_value{value = <<"Good story bro!">>}
            },
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"dcterms:creator">>,
                object = <<"http://dinges.com/456">>
            },
            #triple{
                subject = <<"http://dinges.com/456">>,
                predicate = <<"rdfs:label">>,
                object = #rdf_value{value = <<"Pietje Puk">>}
            },
            #triple{
                subject = <<"http://dinges.com/456">>,
                predicate = <<"dcterms:publisher">>,
                object = <<"http://dinges.com/789">>
            },
            #triple{
                subject = <<"http://dinges.com/789">>,
                predicate = <<"rdfs:label">>,
                object = #rdf_value{value = <<"De uitgever">>}
            }
        ]
    },
    Map = ginger_json_ld:serialize_to_map(Resource),
    Expected = #{
        <<"@id">> => <<"http://dinges.com/123">>,
        <<"dcterms:abstract">> => #{<<"@value">> => <<"Good story bro!">>},
        <<"dcterms:creator">> => #{
            <<"@id">> => <<"http://dinges.com/456">>,
            <<"rdfs:label">> => #{<<"@value">> => <<"Pietje Puk">>},
            <<"dcterms:publisher">> => #{
                <<"@id">> => <<"http://dinges.com/789">>,
                <<"rdfs:label">> => #{<<"@value">> => <<"De uitgever">>}
            }
        }
    },
    ?assertEqual(Expected, Map).

serialize_recursive_test() ->
     Resource = #rdf_resource{
        id = <<"http://dinges.com/123">>,
        triples = [
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"owl:sameAs">>,
                object = <<"http://dinges.com/123">>
            }
        ]
    },
    Map = ginger_json_ld:serialize_to_map(Resource),
    Expected = #{
        <<"@id">> => <<"http://dinges.com/123">>,
        <<"owl:sameAs">> => <<"http://dinges.com/123">>
    },
    ?assertEqual(Expected, Map).

rdf_export_test() ->
    Context = context(),
    Props = [
        {category, text},
        {title, {trans, [
            {nl, <<"Een mooie titel">>}
        ]}},
        {is_published, true}
    ],
    {ok, Id} = m_rsc:insert(Props, z_acl:sudo(Context)),
    Rdf = m_rdf_export:to_rdf(Id, Context),
    Map = ginger_json_ld:serialize_to_map(Rdf),
    ?assertEqual(
        #{
            <<"@id">> => m_rsc:p(Id, uri, Context),
            <<"@type">> => #{
                <<"@id">> => <<"http://purl.org/dc/dcmitype/Text">>
            },
            <<"http://schema.org/dateCreated">> =>
                #{<<"@value">> => m_rsc:p(Id, created, Context)
            },
            <<"http://schema.org/dateModified">> => #{
                <<"@value">> => m_rsc:p(Id, modified, Context)
            },
            <<"http://schema.org/datePublished">> => #{
                <<"@value">> => m_rsc:p(Id, publication_start, Context)
            },
            <<"http://schema.org/name">> => #{
                <<"@value">> => <<"Een mooie titel">>,
                <<"language">> => nl
            }
        },
        Map
    ).

rdf_export_test_no_category_uri_test() ->
    Context = context(),
    Props = [
        {category, meta},
        {is_published, true}
    ],
    {ok, Id} = m_rsc:insert(Props, z_acl:sudo(Context)),
    Rdf = m_rdf_export:to_rdf(Id, Context),
    Map = ginger_json_ld:serialize_to_map(Rdf),

    %% If category has no URI, it must not be added to @type.
    ?assertEqual(false, maps:is_key(<<"@type">>, Map)).

address_to_triples_test() ->
    Props = [
        {address_city, <<"Amsterdam">>},
        {address_street_1, <<"Oudezijds Voorburgwal 282">>},
        {address_country, <<"Nederland">>}
    ],
    Triples = schema_org:property_to_triples({address_country, <<"Amsterdam">>}, Props, context()),
    Map = ginger_json_ld:serialize_to_map(#rdf_resource{triples = Triples}),
    ?assertEqual(
        #{
            <<"http://schema.org/location">> => #{
                <<"@type">> => #{
                    <<"@id">> => <<"http://schema.org/Place">>
                },
                <<"http://schema.org/address">> => #{
                    <<"@type">> => #{
                        <<"@id">> => <<"http://schema.org/PostalAddress">>
                    },
                    <<"http://schema.org/streetAddress">> => #{
                        <<"@value">> => <<"Oudezijds Voorburgwal 282">>
                    },
                    <<"http://schema.org/addressLocality">> => #{
                        <<"@value">> => <<"Amsterdam">>
                    },
                    <<"http://schema.org/addressCountry">> => #{
                        <<"@value">> => <<"Nederland">>
                    }
                }
            }
        },
        Map
    ).

serialize_to_turtle_test() ->
    Resource =
        #rdf_resource{
           id = <<"http://dinges.com/123">>,
           triples = [
                      #triple{
                         subject = <<"http://dinges.com/123">>,
                         predicate = <<"dcterms:creator">>,
                         object = <<"http://dinges.com/456">>
                        },
                      #triple{
                         subject = <<"http://dinges.com/456">>,
                         predicate = <<"rdfs:label">>,
                         object = #rdf_value{value = <<"Pietje Puk">>}
                        },
                      #triple{
                         subject = <<"http://dinges.com/456">>,
                         predicate = <<"http://www.w3.org/2000/01/rdf-schema#label">>,
                         object = #rdf_value{value = <<"Pietje Puk">>}
                        }
                     ]
          },
    Expected = [
                <<"<http://dinges.com/123> dcterms:creator <http://dinges.com/456>.\n">>,
                <<"<http://dinges.com/456> rdfs:label \"Pietje Puk\".\n">>,
                <<"<http://dinges.com/456> <http://www.w3.org/2000/01/rdf-schema#label> \"Pietje Puk\".\n">>
               ],
    Actual = ginger_turtle:serialize(Resource),
    ?assertEqual(Expected, Actual),
    ok.

context() ->
    z_context:new(testsandboxdb).
