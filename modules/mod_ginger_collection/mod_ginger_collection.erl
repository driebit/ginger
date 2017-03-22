-module(mod_ginger_collection).
-author("Driebit <tech@driebit.nl>").

-mod_title("Linked data collections").
-mod_description("Linked data and media collection view and search interface powered by Elasticsearch").
-mod_prio(200).
-mod_depends([mod_ginger_base, mod_elasticsearch]).
-mod_schema(5).

-include_lib("zotonic.hrl").

-export([
    init/1,
    manage_schema/2,
    observe_search_query/2,
    observe_acl_is_allowed/2,
    observe_elasticsearch_fields/3
]).

%% @doc Linked data property mappings
init(Context) ->
    Index = mod_ginger_adlib_elasticsearch:index(Context),
    Mapping = beeldenzoeker_elasticsearch_mapping:default_mapping(),
    
    erlastic_search:create_index(Index),

    %% Update all Elasticsearch types that are currently enabled
    [{ok, _} = erlastic_search:put_mapping(Index, Type, Mapping) || Type
        <- mod_ginger_adlib_elasticsearch:types(Context)],
    ok.
    
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
            {beeldenzoeker_menu, menu, [
                {title, "Beeldenzoeker menu"}
            ]}
        ]
    }.

%% @doc Supplement search arguments with values from JS (that are in get_q()).
observe_search_query(#search_query{search = {beeldenzoeker, Args}} = Query, Context) ->
    Args2 = lists:foldl(
        fun({Key, Value}, Acc) ->
            beeldenzoeker_query:parse_query(Key, Value, Acc)
        end,
        Args,
        z_context:get_q_all_noz(Context)
    ),
    
    ElasticQuery = Query#search_query{search = {elastic, Args2}},
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

%% @doc Boost primary identifier
observe_elasticsearch_fields({elasticsearch_fields, _QueryText}, Fields, _Context) ->
    [
        <<"dcterms:title*^2">>,
        <<"dcterms:identifier^2">>, %% object number
        <<"priref^2">>
    | Fields].

observe_acl_is_allowed(
    #acl_is_allowed{
        object = #acl_mqtt{
        words = [<<"site">>, _, <<"session">>, _, <<"search">>, <<"facets">>]}},
    _Context
) ->
    true;
observe_acl_is_allowed(#acl_is_allowed{}, _Context) ->
    undefined.
