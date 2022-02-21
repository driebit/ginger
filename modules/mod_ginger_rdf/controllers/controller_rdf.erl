%% @doc Serve RDF representation of a resource
-module(controller_rdf).
-author("David de Boer <david@driebit.nl>").

-export([
    init/1,
    service_available/2,
    resource_exists/2,
    content_types_provided/2,
    rdf/2
]).

-include_lib("controller_webmachine_helper.hrl").
-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-record(state, {
    serialization :: atom(),
    ontology :: atom(),
    context :: z:context()
}).

init(Args) ->
    {ok, Args}.

service_available(ReqData, Args) ->
    Context = z_context:new_request(ReqData, [], ?MODULE),
    Context2 = cors_headers:allow_all_cors(Context),
    State = #state{
        context = Context2,
        serialization = proplists:get_value(serialization, Args),
        ontology = proplists:get_value(ontology, Args)
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
    {m_rsc:is_visible(id(Context2), Context2), ReqData, State#state{context = Context2}}.

content_types_provided(ReqData, Context) ->
    {
        [
            {"application/ld+json", rdf},
            {"text/turtle", rdf}
        ],
        ReqData,
        Context
    }.

id(Context) ->
    m_rsc:rid(z_context:get_q(id, Context), Context).

rdf(ReqData, State) ->
    Context1 = z_context:set_reqdata(ReqData, State#state.context),
    RdfResource = m_rdf_export:to_rdf(id(Context1), [State#state.ontology], Context1),
    SerializedRdf = serialize(RdfResource, State#state.serialization),
    ?WM_REPLY(SerializedRdf, Context1).

%% @doc Serialize RDF resource into one of the RDF serialization formats.
-spec serialize(#rdf_resource{}, json_ld | turtle) -> binary().
serialize(RdfResource, json_ld) ->
    JsonLd = ginger_json_ld:serialize_to_map(RdfResource),
    jsx:encode(JsonLd);
serialize(RdfResource, turtle) ->
    ginger_turtle:serialize(RdfResource).
