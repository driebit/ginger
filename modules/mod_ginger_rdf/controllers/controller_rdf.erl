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
    context :: z:context()
}).

init(Args) ->
    {ok, Args}.

service_available(ReqData, Args) ->
    Context = z_context:new_request(ReqData, [], ?MODULE),
    Context2 = set_cors_headers(Context),
    State = #state{context = Context2, serialization = proplists:get_value(serialization, Args)},
    case wrq:method(ReqData) of
        'OPTIONS' ->
            {{halt, 204}, z_context:get_reqdata(Context), State};
        _ ->
            {true, z_context:get_reqdata(Context), State}
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

rdf(ReqData, #state{context = Context, serialization = Serialization}) ->
    Context1 = z_context:set_reqdata(ReqData, Context),
    RdfResource = m_rdf:to_triples(id(Context1), Context),
    SerializedRdf = serialize(RdfResource, Serialization),
    ?WM_REPLY(SerializedRdf, Context).

%% @doc Serialize RDF resource into one of the RDF serialization formats.
-spec serialize(#rdf_resource{}, json_ld | turtle) -> binary().
serialize(RdfResource, json_ld) ->
    JsonLd = ginger_json_ld:serialize_to_map(RdfResource),
    jsx:encode(JsonLd);
serialize(RdfResource, turtle) ->
    ginger_turtle:serialize(RdfResource).

%% @doc Always enable CORS for this controller.
%%      Unlike controller_api:set_cors_header, this function doesn't look at the
%%      configuration but unconditionally exposes this controller between
%%      domains. This makes sharing content much easier.
set_cors_headers(Context) ->
    lists:foldl(
        fun ({K, Def}, Acc) ->
            case m_config:get_value(site, K, Def, Context) of
                undefined ->
                    Acc;
                V ->
                    z_context:set_resp_header(atom_to_list(K), V, Acc)
            end
        end,
        Context,
        [
            {'Access-Control-Allow-Origin', "*"},
            {'Access-Control-Max-Age', undefined}
        ]
    ).
