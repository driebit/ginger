-module(mod_beeldenzoeker).
-author("Driebit <tech@driebit.nl>").

-mod_title("Beeldenzoeker").
-mod_description("Media collections powered by Elasticsearch").
-mod_prio(200).
-mod_depends([mod_ginger_base]).
-mod_schema(4).

-include_lib("zotonic.hrl").
-include_lib("mod_elasticsearch/include/elasticsearch.hrl").

-export([
    manage_schema/2
]).

manage_schema(_Version, _Context) ->
    #datamodel{
        categories = [
            {beeldenzoeker_query, elastic_query, [
                {title, {trans, [
                    {nl, <<"Zoekopdracht in Beeldenzoeker">>},
                    {en, <<"Media discovery search query">>}
                ]}},
                {is_unfindable, true}
            ]}
        ],
        resources = [
            {beeldenzoeker, collection, [
                {title, {trans, [{nl, <<"Beeldenzoeker">>},
                    {en, <<"Media discovery">>}]}},
                {language, [en, nl]},
                {is_unfindable, true}
            ]},
            {beeldenzoeker, menu, [
                {title, "Beeldenzoeker menu"}
            ]}
        ]
    }.
