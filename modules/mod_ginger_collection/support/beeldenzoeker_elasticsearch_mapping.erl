-module(beeldenzoeker_elasticsearch_mapping).

-export([
    default_mapping/0
]).

%% @doc Default mappings are based on linked data predicates.
default_mapping() ->
    Mapping = #{
        <<"properties">> => #{
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
            }}
        ]
    },
    
    {elasticsearch_mapping:hash(Mapping), Mapping}.
