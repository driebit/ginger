-module(ginger_adlib_elasticsearch2_index_mapping).

-export([
    default_mapping/1
]).

%% @doc Default mappings are based on linked data predicates.
default_mapping(Context) ->
    Mapping = #{
        <<"properties">> => #{
            <<"es_type">> => #{
                <<"type">> => <<"keyword">>
            },
            <<"acquisition.date">> => #{
                <<"type">> => <<"date">>
            },
            <<"dcterms:created">> => #{
                <<"type">> => <<"date">>
            },
            <<"dbo:creationYear">> => #{
                <<"type">> => <<"date">>
            },
            <<"dbo:productionStartYear">> => #{
                <<"type">> => <<"date">>
            },
            <<"dbo:productionEndDate">> => #{
                <<"type">> => <<"date">>
            },
            <<"dbo:productionEndYear">> => #{
                <<"type">> => <<"date">>
            },
            <<"dcterms:creator">> => #{
                <<"type">> => <<"nested">>,
                <<"properties">> => #{
                    <<"dbpedia-owl:birthDate">> => #{
                        <<"type">> => <<"date">>
                    },
                    <<"dbpedia-owl:deathDate">> => #{
                        <<"type">> => <<"date">>
                    },
                    <<"rdfs:label">> => #{
                        <<"type">> => <<"text">>,
                        <<"fields">> => #{
                            <<"keyword">> => #{
                                <<"type">> => <<"keyword">>,
                                <<"ignore_above">> => 256
                            }
                        }
                    }
                }
            },
            <<"rdf:type.rdfs:label">> => #{
                <<"type">> => <<"text">>,
                <<"fields">> => #{
                    <<"keyword">> => #{
                        <<"type">> => <<"keyword">>,
                        <<"ignore_above">> => 256
                    }
                }
            },
            <<"dcterms:subject.rdfs:label">> => #{
                <<"type">> => <<"text">>,
                <<"fields">> => #{
                    <<"keyword">> => #{
                        <<"type">> => <<"keyword">>,
                        <<"ignore_above">> => 256
                    }
                }
            },
            <<"schema:about.rdfs:label">> => #{
                <<"type">> => <<"text">>,
                <<"fields">> => #{
                    <<"keyword">> => #{
                        <<"type">> => <<"keyword">>,
                        <<"ignore_above">> => 256
                    },
                    <<"keyword_global">> => #{
                        <<"type">> => <<"keyword">>,
                        <<"ignore_above">> => 256
                    }
                }
            }
        },
        <<"dynamic_templates">> => [
            #{<<"date">> => #{
                <<"match">> => <<"dcterms:date">>,
                <<"mapping">> => #{
                    <<"type">> => <<"date">>
                }
            }},
            #{<<"strings">> => #{
                <<"match_mapping_type">> => <<"string">>,
                <<"match">> => <<"title*">>,
                <<"mapping">> => #{
                    <<"type">> => <<"text">>
                }
            }},
            #{<<"strings">> => #{
                <<"match_mapping_type">> => <<"string">>,
                <<"match">> => <<"dc:title*">>,
                <<"mapping">> => #{
                    <<"type">> => <<"text">>
                }
            }},
            #{<<"strings">> => #{
                <<"match_mapping_type">> => <<"string">>,
                <<"match">> => <<"dcterms:title*">>,
                <<"mapping">> => #{
                    <<"type">> => <<"text">>
                }
            }},
            #{<<"strings">> => #{
                <<"match_mapping_type">> => <<"string">>,
                <<"match">> => <<"schema:title*">>,
                <<"mapping">> => #{
                    <<"type">> => <<"text">>
                }
            }}
        ] ++ elasticsearch2_mapping:dynamic_language_mapping(Context)
    },
    {elasticsearch2_mapping:hash(Mapping), Mapping}.
