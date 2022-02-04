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
                predicate = rdf_property:rdf(<<"type">>),
                object = <<"http://purl.org/dc/dcmitype/Text">>
            },
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
        <<"@type">> => [
            <<"http://purl.org/dc/dcmitype/Text">>
        ],
        <<"dcterms:abstract">> => [
            #{<<"@value">> => <<"Good story bro!">>}
        ],
        <<"dcterms:creator">> => [
            #{
                <<"@id">> => <<"http://dinges.com/456">>,
                <<"rdfs:label">> => [
                    #{<<"@value">> => <<"Pietje Puk">>}
                ]
            }
        ],
        <<"owl:sameAs">> => [
            #{<<"@id">> => <<"http://nl.dbpedia.org/resource/Dinges">>}
        ]
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
        <<"dcterms:abstract">> => [
            #{<<"@value">> => <<"Good story bro!">>}
        ],
        <<"dcterms:creator">> => [
            #{
                <<"@id">> => <<"http://dinges.com/456">>,
                <<"rdfs:label">> => [
                    #{<<"@value">> => <<"Pietje Puk">>}
                ],
                <<"dcterms:publisher">> => [
                    #{
                        <<"@id">> => <<"http://dinges.com/789">>,
                        <<"rdfs:label">> => [
                            #{<<"@value">> => <<"De uitgever">>}
                        ]
                    }
                ]
            }
        ]
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
        <<"owl:sameAs">> => [
            <<"http://dinges.com/123">>
        ]
    },
    ?assertEqual(Expected, Map).

deserialize_test() ->
    Resource = #rdf_resource{
        id = <<"http://dinges.com/123">>,
        triples = [
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = rdf_property:dcterms(<<"abstract">>),
                object = #rdf_value{value = <<"Good story bro!">>}
            },
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = rdf_property:rdf(<<"type">>),
                object = #rdf_value{value = <<"http://purl.org/dc/dcmitype/Text">>}
            }
        ]
    },
    Serialized = ginger_json_ld:serialize_to_map(Resource),
    Deserialized = ginger_json_ld:deserialize(Serialized),
    ?assertEqual(Resource, Deserialized).

rdf_export_test() ->
    Context = context(),
    %% Predicate must have a URI to be included in export.
    m_rsc:update(author, [{uri, <<"http://schema.org/author">>}], z_acl:sudo(Context)),

    Props = [
        {category, text},
        {title, {trans, [
            {nl, <<"Een mooie titel">>} %% Multilingual property.
        ]}},
        {is_published, true}
    ],
    AuthorProps = [
        {category, person},
        {title, <<"Auteur van het artikel">>}, %% Monolingual property.
        {is_published, true}
    ],
    {ok, Id} = m_rsc:insert(Props, z_acl:sudo(Context)),
    {ok, AuthorId} = m_rsc:insert(AuthorProps, z_acl:sudo(Context)),
    {ok, _EdgeId} = m_edge:insert(Id, author, AuthorId, z_acl:sudo(Context)),
    Rdf = m_rdf_export:to_rdf(Id, Context),
    Map = ginger_json_ld:serialize_to_map(Rdf),
    ?assertEqual(
        #{
            <<"@id">> => m_rsc:p(Id, uri, Context),
            <<"@type">> => [
                <<"http://purl.org/dc/dcmitype/Text">>
            ],
            <<"http://schema.org/dateCreated">> => [
                #{
                    <<"@value">> => m_rsc:p(Id, created, Context),
                    <<"@type">> => rdf_property:schema(<<"DateTime">>)
                }
            ],
            <<"http://schema.org/dateModified">> => [
                #{
                    <<"@value">> => m_rsc:p(Id, modified, Context),
                    <<"@type">> => rdf_property:schema(<<"DateTime">>)
                }
            ],
            <<"http://schema.org/datePublished">> => [
                #{
                    <<"@value">> => m_rsc:p(Id, publication_start, Context),
                    <<"@type">> => rdf_property:schema(<<"DateTime">>)
                }
            ],
            <<"http://schema.org/headline">> => [
                #{
                    <<"@value">> => <<"Een mooie titel">>,
                    <<"@language">> => nl
                }
            ],
            <<"http://schema.org/author">> => [
                #{
                    <<"@id">> => m_rsc:p(AuthorId, uri, Context),
                    <<"http://schema.org/title">> => [
                        #{
                            <<"@value">> => <<"Auteur van het artikel">>,
                            <<"@language">> => en %% The site's default language.
                        }
                    ]
                }
            ]
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
            <<"http://schema.org/location">> => [
                #{
                    <<"@type">> => [
                        <<"http://schema.org/Place">>
                    ],
                    <<"http://schema.org/address">> => [
                        #{
                            <<"@type">> => [
                                <<"http://schema.org/PostalAddress">>
                            ],
                            <<"http://schema.org/streetAddress">> => [
                                #{
                                    <<"@value">> => <<"Oudezijds Voorburgwal 282">>
                                }
                            ],
                            <<"http://schema.org/addressLocality">> => [
                                #{
                                    <<"@value">> => <<"Amsterdam">>
                                }
                            ],
                            <<"http://schema.org/addressCountry">> => [
                                #{
                                    <<"@value">> => <<"Nederland">>
                                }
                            ]
                        }]
                }
            ]
        },
        Map
    ).

serialize_to_turtle_test() ->
    NestedRsc1 = #rdf_resource{
                    id = <<"http://example.com/1">>,
                    triples = [
                               #triple{
                                  subject = <<"http://dinges.com/123">>,
                                  predicate = <<"foaf:age">>,
                                  object = #rdf_value{value = 42}
                                 }
                              ]
                   },
    NestedRsc2 = #rdf_resource{
                    id = undefined,
                    triples = [
                               #triple{
                                  subject = <<"http://dinges.com/123">>,
                                  predicate = <<"foaf:age">>,
                                  object = #rdf_value{value = 42}
                                 }
                              ]
                   },
    Resource =
        #rdf_resource{
           id = <<"http://dinges.com/123">>,
           triples = [
                      #triple{
                         subject = <<"http://dinges.com/123">>,
                         predicate = <<"foaf:age">>,
                         object = NestedRsc1
                        },
                      #triple{
                         subject = <<"http://dinges.com/123">>,
                         predicate = <<"foaf:age">>,
                         object = NestedRsc2
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
                         predicate = <<"http://www.w3.org/2000/01/rdf-schema#label">>,
                         object = #rdf_value{value = <<"Pietje Puk">>}
                        }
                     ]
          },
    Expected = [
                <<"<http://dinges.com/123> foaf:age <http://example.com/1>.">>,
                <<"<http://example.com/1> foaf:age \"42\".">>,
                <<"<http://dinges.com/123> foaf:age _:121203557.">>,
                <<"_:121203557 foaf:age \"42\".">>,
                <<"<http://dinges.com/123> dcterms:creator <http://dinges.com/456>.">>,
                <<"<http://dinges.com/456> rdfs:label \"Pietje Puk\".">>,
                <<"<http://dinges.com/456> <http://www.w3.org/2000/01/rdf-schema#label> \"Pietje Puk\".">>,
                <<>>
               ],
    Actual = binary:split(erlang:list_to_binary(ginger_turtle:serialize(Resource)), <<"\n">>, [global]),
    ?assertEqual(Expected, Actual),
    ok.

context() ->
    z_context:new(testsandboxdb).
