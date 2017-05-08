-module(mod_ginger_collection).
-author("Driebit <tech@driebit.nl>").

-mod_title("Linked data collections").
-mod_description("Linked data and media collection view and search interface powered by Elasticsearch").
-mod_prio(200).
-mod_depends([mod_ginger_base, mod_elasticsearch]).
-mod_schema(5).

-include_lib("zotonic.hrl").

-export([
    manage_schema/2,
    observe_search_query/2,
    observe_acl_is_allowed/2,
    observe_elasticsearch_fields/3
]).

manage_schema(_, Context) ->
    elasticsearch_index(Context),
    datamodel().

elasticsearch_index(Context) ->
    {Version, Mapping} = beeldenzoeker_elasticsearch_mapping:default_mapping(),
    Index = mod_ginger_adlib_elasticsearch:index(Context),
    %% Apply default mapping to all types
    Mappings = [{Type, Mapping} || Type <- mod_ginger_adlib_elasticsearch:types(Context)],
    elasticsearch_index:upgrade(Index, Mappings, Version, Context).
    
datamodel() ->
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
        #search_result{facets = Facets} = Result when is_map(Facets)->
            %% For now separate notification for facets
            ok = z_mqtt:publish("~session/search/facets", jsx:encode(Facets), Context),
            Result;
        #search_result{facets = Facets} = Result->
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
observe_acl_is_allowed(#acl_is_allowed{action = view_ginger_collection, object = object}, Context) ->
    %% Retrieve object for ACL checking on its contents
    case m_collection_object:get(
        z_context:get_q(<<"database">>, Context),
        z_context:get_q(<<"object_id">>, Context),
        Context
    ) of
        undefined ->
            undefined;
        #{<<"_source">> := Object} when is_list(Object) ->
            %% BC with jsx 2.0
            z_acl:is_allowed(view, maps:from_list(Object), Context);
        #{<<"_source">> := Object} when is_map(Object) ->
            z_acl:is_allowed(view, Object, Context)
    end;
observe_acl_is_allowed(#acl_is_allowed{}, _Context) ->
    undefined.
