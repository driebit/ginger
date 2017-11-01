-module(mod_ginger_collection).
-author("Driebit <tech@driebit.nl>").

-mod_title("Linked data collections").
-mod_description("Linked data and media collection view and search interface powered by Elasticsearch").
-mod_prio(200).
-mod_depends([mod_ginger_base, mod_elasticsearch, mod_ginger_rdf]).
-mod_schema(6).

-include_lib("zotonic.hrl").

-export([
    init/1,
    index/1,
    manage_schema/2,
    observe_search_query/2,
    observe_acl_is_allowed/2,
    observe_elasticsearch_fields/3
]).

init(Context) ->
    default_config(index, index(Context), Context).

%% @doc Get Elasticsearch index name used for collections.
-spec index(z:context()) -> binary().
index(Context) ->
    Default = <<(elasticsearch:index(Context))/binary, "_collection">>,
    case m_config:get_value(?MODULE, index, Context) of
        undefined -> Default;
        <<>> -> Default;
        Value -> z_convert:to_binary(Value)
    end.

manage_schema(_, _Context) ->
    datamodel().
 
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
            collection_query:parse_query(Key, Value, Acc)
        end,
        [],
        lists:merge(Args, z_context:get_q_all_noz(Context))
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
observe_search_query(#search_query{search = {dbpedia, _}} = Query, _Context) ->
    dbpedia:search(Query);
observe_search_query(#search_query{}, _Context) ->
    undefined.

%% @doc Boost primary identifier
observe_elasticsearch_fields({elasticsearch_fields, #{<<"prefix">> := _Prefix}}, Fields, _Context) ->
    [<<"dcterms:title*^2">> | Fields];
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

default_config(Key, Value, Context) ->
    case m_config:get_value(?MODULE, Key, Context) of
        undefined ->
            m_config:set_value(?MODULE, Key, Value, Context);
        _ ->
            ok
    end.
