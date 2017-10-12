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
