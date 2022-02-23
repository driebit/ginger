%% @doc Serve Hydra representation of a collection resource or one of its subcategories.
%% @see https://www.hydra-cg.com/spec/latest/core/
-module(controller_hydra).
-author("David de Boer <david@ddeboer.nl>").

-export([
    init/1,
    service_available/2,
    resource_exists/2,
    content_types_provided/2,
    to_json_ld/2,
    to_turtle/2
]).

-include_lib("controller_webmachine_helper.hrl").
-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-record(state, {
    ontology :: atom(),
    limit :: non_neg_integer(),
    query_type :: atom(),
    context :: z:context()
}).

init(Args) ->
    {ok, Args}.

service_available(ReqData, Args) ->
    Context = z_context:new_request(ReqData, [], ?MODULE),
    Context2 = cors_headers:allow_all_cors(Context),
    State = #state{
        context = Context2,
        ontology = proplists:get_value(ontology, Args),
        query_type = proplists:get_value(query, Args, query),
        limit = proplists:get_value(limit, Args, 100)
    },
    case wrq:method(ReqData) of
        'OPTIONS' ->
            {{halt, 204}, z_context:get_reqdata(Context2), State};
        _ ->
            {true, z_context:get_reqdata(Context2), State}
    end.

resource_exists(ReqData, State = #state{context = Context}) ->
    Context1 = ?WM_REQ(ReqData, Context),
    Context2 = z_context:ensure_qs(Context1),
    Id = id(Context2),
    {m_rsc:is_visible(Id, Context2) andalso m_rsc:is_a(Id, collection, Context), ReqData, State#state{context = Context2}}.

content_types_provided(ReqData, Context) ->
    {
        [
            {"application/ld+json", to_json_ld},
            {"text/turtle", to_turtle}
        ],
        ReqData,
        Context
    }.

to_json_ld(ReqData, State) ->
    {serialize(to_hydra(ReqData, State), json_ld), ReqData, State}.

to_turtle(ReqData, State) ->
    {serialize(to_hydra(ReqData, State), turtle), ReqData, State}.

-spec to_hydra(#wm_reqdata{}, #state{}) -> m_rdf:resource().
to_hydra(ReqData, State) ->
    Context = z_context:set_reqdata(ReqData, State#state.context),
    RequestArgs = wrq:req_qs(ReqData),
    Page = z_convert:to_integer(proplists:get_value("page", RequestArgs, 1)),
    QueryId = id(Context),
    Limit = State#state.limit,

    #search_result{
        pages = Pages,
        result = Result,
        total = Total,
        next = Next,
        prev = Previous
    } = z_search:search_pager({State#state.query_type, search_arguments(QueryId, Context)}, Page, Limit, Context),
    RdfResults = [m_rdf_export:to_rdf(Id, [State#state.ontology], Context) || Id <- Result, m_rsc:is_visible(Id, Context)],

    HydraCollectionUrl = hydra_url(QueryId, page(RequestArgs, undefined), Context), %% The Hydra collection.
    HydraViewUrl = hydra_url(QueryId, page(RequestArgs, Page), Context), %% The paged view on the Hydra collection.
    #rdf_resource{
        id = HydraCollectionUrl,
        triples = [
            #triple{
                subject = HydraCollectionUrl,
                predicate = rdf_property:rdf(<<"type">>),
                object = rdf_property:hydra(<<"Collection">>)
            },
            #triple{
                subject = HydraCollectionUrl,
                predicate = rdf_property:hydra(<<"totalItems">>),
                object = #rdf_value{value = Total}
            },
            #triple{
                subject = HydraCollectionUrl,
                predicate = rdf_property:hydra(<<"view">>),
                object = HydraViewUrl
            },
            #triple{
                subject = HydraViewUrl,
                predicate = rdf_property:hydra(<<"first">>),
                object = hydra_url(QueryId, page(RequestArgs, 1), Context)
            },
            #triple{
                subject = HydraViewUrl,
                predicate = rdf_property:hydra(<<"next">>),
                object = hydra_url(QueryId, page(RequestArgs, Next), Context)
            },
            #triple{
                subject = HydraViewUrl,
                predicate = rdf_property:hydra(<<"previous">>),
                object = hydra_url(QueryId, page(RequestArgs, other_page(Previous, Page)), Context)
            },
            #triple{
                subject = HydraViewUrl,
                predicate = rdf_property:hydra(<<"last">>),
                object = hydra_url(QueryId, page(RequestArgs, Pages), Context)
            }
            |
            [#triple{
                subject = HydraCollectionUrl,
                predicate = rdf_property:hydra(<<"member">>),
                object = RdfResult
            } || RdfResult <- RdfResults]
        ]
    }.

%% @doc Serialize RDF resource into one of the RDF serialization formats.
-spec serialize(#rdf_resource{}, json_ld | turtle) -> binary().
serialize(RdfResource, json_ld) ->
    JsonLd = ginger_json_ld:serialize_to_map(RdfResource),
    jsx:encode(JsonLd);
serialize(RdfResource, turtle) ->
    ginger_turtle:serialize(RdfResource).

hydra_url(_, undefined, _) ->
    undefined;
hydra_url(QueryId, QueryParams, Context) ->
    z_dispatcher:url_for(hydra, [{use_absolute_url, true}, {id, QueryId} | QueryParams], undefined, Context).

page(_, false) ->
    undefined;
page(_, 0) ->
    undefined;
page(QueryParams, undefined) ->
    proplists:delete("page", QueryParams);
page(QueryParams, PageNumber) when is_number(PageNumber) andalso PageNumber >= 1 ->
    [{"page", PageNumber} | proplists:delete("page", QueryParams)].

id(Context) ->
    m_rsc:rid(z_context:get_q(id, Context), Context).

%% @doc Even if we're on the first page, Zotonic returns a previous page (with value 1). Filter that out to hide the
%% previous link when we're on the first page.
other_page(Same, Same) ->
    false;
other_page(Other, _) ->
    Other.

%% @doc If the resource has a query text, use that to search.
%%      If not, fall back to the resource's outgoing haspart edges.
-spec search_arguments(m_rsc:resource(), z:context()) -> proplists:proplist().
search_arguments(Id, Context) ->
    case m_rsc:p(Id, query, Context) of
        <<>> ->
            [{is_published, true}, {hassubject, [Id, haspart]}];
        _QueryText ->
            [{is_published, true}, {query_id, Id}]
    end.
