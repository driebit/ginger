-module(m_ginger_rest_tests).

-include_lib("eunit/include/eunit.hrl").
-include_lib("zotonic.hrl").

rsc_blocks_test() ->
    {ok, Id} = m_rsc:insert(
        [
            {category, text},
            {blocks, [
                [
                    {type, <<"header">>},
                    {name, <<"translated_header">>},
                    {header, {trans, [
                        {nl, <<"Vertaalde header">>},
                        {en, <<"Translated header">>}
                    ]}},
                    {body, <<"Untranslated body">>}
                ],

                [
                    {type, <<"page">>},
                    {name, <<"page2">>},
                    {style, <<"quote">>},
                    {rsc_id, 19013}
                ]
            ]}
        ],
        context()
    ),
    #{<<"blocks">> := [Block1, Block2]} = Rest = m_ginger_rest:rsc(Id, context()),
    ?assertEqual(
        [
            {nl, <<"Vertaalde header">>},
            {en, <<"Translated header">>}
        ],
        maps:get(<<"header">>, Block1)
    ),
    ?assertEqual(
        [{nl, <<"Untranslated body">>}],
        maps:get(<<"body">>, Block1)
    ),

    ?assertEqual(<<"page">>, maps:get(<<"type">>, Block2)),
    ?assertEqual(<<"page2">>, maps:get(<<"name">>, Block2)),
    ?assertEqual(<<"quote">>, maps:get(<<"style">>, Block2)),
    ?assertEqual(19013, maps:get(<<"rsc_id">>, Block2)),

    jsx:encode(Rest).

context() ->
    z_acl:sudo(z_context:new(testsandboxdb)).
