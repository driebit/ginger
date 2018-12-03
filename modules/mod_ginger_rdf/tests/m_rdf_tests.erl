-module(m_rdf_tests).

-include_lib("eunit/include/eunit.hrl").
-include("zotonic.hrl").
-include("../include/rdf.hrl").

m_find_value_test() ->
    Input = #rdf_resource{
        id = <<"http://dinges.com/123">>,
        triples = [
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"dc:author">>,
                object = #rdf_value{value = <<"Author 1">>}
              },
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"dc:author">>,
                object = #rdf_value{value = <<"Author 2">>}
            },
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"single_value">>,
                object = #rdf_value{
                    value = <<"Value1">>
                }
            },
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"single_value_in_list">>,
                object = #rdf_value{
                    value = <<"Value2">>
                }
            },
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"nonrecord_content">>,
                object = <<"Value">>
            },
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"dc:title">>,
                object = #rdf_value{
                    language = <<"nl-NL">>,
                    value = <<"Goed verhaal broer!">>
                }
            },
            #triple{
                subject = <<"http://dinges.com/123">>,
                predicate = <<"dc:title">>,
                object = #rdf_value{
                    language = <<"en-US">>,
                    value = <<"Good story bro!">>
                }
            }
        ]
    },
    Context = z_context:new(testsandboxdb),
    ContextWithNonPresentLanguage = z_context:set_language(de, Context),
    ?assertEqual(
        [<<"Goed verhaal broer!">>, <<"Good story bro!">>],
        m_rdf:m_find_value(<<"dc:title">>, #m{value = Input}, ContextWithNonPresentLanguage)
    ),
    ContextWithLanguage = z_context:set_language(nl, Context),
    ?assertEqual(
        [<<"Author 1">>, <<"Author 2">>],
        m_rdf:m_find_value(<<"dc:author">>, #m{value = Input}, ContextWithLanguage)
    ),
    ?assertEqual(
        <<"Value">>,
        m_rdf:m_find_value(<<"nonrecord_content">>, #m{value = Input}, ContextWithLanguage)
    ),
    ?assertEqual(
        <<"Value1">>,
        m_rdf:m_find_value(<<"single_value">>, #m{value = Input}, ContextWithLanguage)
    ),
    ?assertEqual(
        [<<"Value2">>],
        m_rdf:m_find_value(<<"single_value_in_list">>, #m{value = Input}, ContextWithLanguage)
    ),
    ?assertEqual(
        [<<"Value3">>],
        m_rdf:m_find_value(<<"nonrecord_content_in_list">>, #m{value = Input}, ContextWithLanguage)
    ),
    ?assertEqual(
        [<<"Goed verhaal broer!">>, <<"Good story bro!">>],
        m_rdf:m_find_value(<<"dc:title">>, #m{value = Input}, ContextWithLanguage)
    ).
