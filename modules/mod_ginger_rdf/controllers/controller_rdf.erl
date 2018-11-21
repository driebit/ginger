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
    {ok, #state{serialization = proplists:get_value(serialization, Args)}}.

service_available(ReqData, State) ->
    Context  = z_context:new(ReqData, ?MODULE),
    z_context:lager_md(Context),
    Context1 = z_context:ensure_all(Context),
    ReqData1 = set_cors_headers(ReqData, Context1),
    case wrq:method(ReqData1) of
        'OPTIONS' ->
            {{halt, 204}, ReqData1, State#state{context = Context1}};
        _ ->
            {true, ReqData1, State#state{context = Context1}}
    end.

resource_exists(ReqData, State = #state{context = Context}) ->
    {m_rsc:exists(z_context:get_q(id, Context), Context), ReqData, State}.

content_types_provided(ReqData, State) ->
    {
        [
            {"application/ld+json", rdf},
            {"text/turtle", rdf}
        ],
        ReqData,
        State
    }.

rdf(_ReqData, #state{context = Context, serialization = Serialization}) ->
    Id = m_rsc:rid(z_context:get_q(id, Context), Context),
    RdfResource = m_rdf:to_triples(Id, Context),
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
set_cors_headers(ReqData, Context) ->
    lists:foldl(
        fun ({K, Def}, Acc) ->
            case m_config:get_value(site, K, Def, Context) of
                undefined ->
                    Acc;
                V ->
                    wrq:set_resp_header(z_convert:to_list(K), z_convert:to_list(V), Acc)
            end
        end,
        ReqData,
        [
            {'Access-Control-Allow-Origin', "*"},
            {'Access-Control-Max-Age', undefined}
        ]
    ).
