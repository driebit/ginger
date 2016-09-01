%% @doc Serve RDF representation of a resource
-module(controller_rdf).
-author("David de Boer <david@driebit.nl>").

-export([
    init/1,
    service_available/2,
    is_authorized/2,
    content_types_provided/2,
    json_ld/2
]).

-include_lib("controller_webmachine_helper.hrl").
-include_lib("zotonic.hrl").

init(ConfigProps) ->
    {ok, ConfigProps}.

service_available(ReqData, DispatchArgs) when is_list(DispatchArgs) ->
    Context  = z_context:new(ReqData, ?MODULE),
    Context1 = z_context:set(DispatchArgs, Context),
    z_context:lager_md(Context1),
    ReqData1 = set_cors_headers(ReqData, Context1),
    case wrq:method(ReqData1) of
        'OPTIONS' ->
            {{halt, 204}, ReqData1, Context1};
        _ ->
            {true, ReqData1, Context1}
    end.

is_authorized(ReqData, Context) ->
    Context1 = ?WM_REQ(ReqData, Context),
    Context2 = z_context:ensure_all(Context1),
    ?WM_REPLY(true, Context2).

content_types_provided(ReqData, Context) ->
    {[{"application/ld+json", json_ld}], ReqData, Context}.

json_ld(ReqData, Context) ->
    Context1 = ?WM_REQ(ReqData, Context),
    Result = case z_context:get_q(id, Context1) of
        undefined ->
            undefined;
        Id ->
            RdfResource = m_rdf:to_triples(z_convert:to_integer(Id), Context1),
            JsonLd = ginger_json_ld:serialize(RdfResource),
            mochijson2:encode(JsonLd)
    end,
    ?WM_REPLY(Result, Context1).

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
