-module(mod_ginger_collection).
-author("Driebit <tech@driebit.nl>").

-mod_title("Linked data collections").
-mod_description("Linked data and media collection view and search interface powered by Elasticsearch").
-mod_prio(200).
-mod_depends([mod_ginger_base, elasticsearch, mod_ginger_rdf]).
-mod_schema(6).

-include_lib("zotonic.hrl").

-export([
    init/1,
    manage_schema/2,
    observe_search_query/2,
    observe_acl_is_allowed/2,
    observe_elasticsearch_fields/3
]).

init(Context) ->
    default_config(index, m_ginger_collection:collection_index(Context), Context).

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

%% @doc Supplement search arguments with filter values from JS
%%      (retrieved from z_context:get_q()).
observe_search_query(#search_query{search = {ginger_collection, _Args}} = Query, Context) ->
    collection_search:search(Query, Context);
observe_search_query(#search_query{search = {query, Args}} = Query, Context) ->
    case collection_query:is_collection_query(Args) of
        false ->
            undefined;
        true ->
            %% A collection search query (with search argument 'collection')
            collection_search:search(Query, Context)
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
