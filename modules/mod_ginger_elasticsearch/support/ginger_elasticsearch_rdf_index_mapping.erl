%% @doc Elasticsearch index mapping for storing RDF graphs.
-module(ginger_elasticsearch_rdf_index_mapping).

-export([
    mapping/1
]).

mapping(Context) ->
    Mapping = #{
        <<"properties">> => #{
            <<"triples">> => #{
                <<"type">> => <<"nested">>,
                <<"properties">> => #{
                    <<"object_date">> => #{
                        <<"type">> => <<"date">>
                    },
                    <<"object_value">> => #{
                        <<"type">> => <<"string">>
                    }
                }
            }
        },
        <<"dynamic_templates">> => elasticsearch_mapping:dynamic_language_mapping(Context)
    },

    {elasticsearch_mapping:hash(Mapping), Mapping}.
