-module(mod_beeldenzoeker).
-author("Driebit <tech@driebit.nl>").

-mod_title("Beeldenzoeker").
-mod_description("Media collections powered by Elasticsearch").
-mod_prio(200).
-mod_depends([mod_ginger_base]).
-mod_schema(5).

-include_lib("zotonic.hrl").
-include_lib("mod_elasticsearch/include/elasticsearch.hrl").

-export([
    manage_schema/2,
    observe_search_query/2,
    observe_acl_is_allowed/2
]).

manage_schema(_Version, _Context) ->
    #datamodel{
        categories = [
            {beeldenzoeker_query, elastic_query, [
                {title, {trans, [
                    {nl, <<"Zoekopdracht in Beeldenzoeker">>},
                    {en, <<"Media discovery search query">>}
                ]}},
                {is_unfindable, false}
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

%% @doc Supplement search arguments with values from JS (that are in get_q()).
observe_search_query(#search_query{search = {beeldenzoeker, Args}} = Query, Context) ->
    Args2 = Args ++ lists:map(
        fun({Name, Props}) ->
            {agg, [Name, terms, Props]}
        end,
        z_context:get_q(<<"facets">>, Context, [])
    ),

    Args3 = case z_context:get_q(<<"subject">>, Context, []) of
        [] ->
            Args2;
        Subjects ->
            Args2 ++ lists:map(
                fun(Subject) ->
                    {filter, [<<"association.subject.keyword">>, Subject]}
                end,
                Subjects
            )
    end,
    
    Args4 = case z_context:get_q(<<"subset">>, Context, []) of
        [] ->
            Args3;
        [<<"collection">>, <<"event">>] ->
            %% don't filter
            Args3;
        [<<"collection">>] ->
            Args3 ++ [{filter, [<<"association.subject.keyword">>, '<>', <<"evenement">>]}];
        [<<"event">>] ->
            Args3 ++ [{filter, [<<"association.subject.keyword">>, <<"evenement">>]}]
    end,
    
    ElasticQuery = Query#search_query{search = {elastic, Args4}},
    case z_notifier:first(ElasticQuery, Context) of
        undefined ->
            undefined;
        #search_result{facets = Facets} = Result ->
            %% For now separate notification for facets
            ok = z_mqtt:publish("~session/search/facets", Facets, Context),
            Result
    end;
observe_search_query(#search_query{}, _Context) ->
    undefined.


observe_acl_is_allowed(
    #acl_is_allowed{
        object = #acl_mqtt{
        words = [<<"site">>, _, <<"session">>, _, <<"search">>, <<"facets">>]}},
    _Context
) ->
    true;
observe_acl_is_allowed(#acl_is_allowed{}, _Context) ->
    undefined.
