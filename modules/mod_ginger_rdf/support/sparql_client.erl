%% @doc A basic SPARQL client.
-module(sparql_client).

-export([
    describe/2,
    query/2,
    query/3,
    get_resource/3
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-export_type([
    url/0
]).

-type url() :: binary().

%% @doc Describe a single resource
-spec describe(url(), url()) -> m_rdf:rdf_resource() | undefined.
describe(Endpoint, <<"https://", _/binary>> = Uri) ->
    describe(Endpoint, <<"<", Uri/binary, ">">>);
describe(Endpoint, <<"http://", _/binary>> = Uri) ->
    describe(Endpoint, <<"<", Uri/binary, ">">>);
describe(Endpoint, Clause) ->
    query(Endpoint, (<<"DESCRIBE ", Clause/binary>>)).

%% @doc Execute a SPARQL query.
-spec query(url(), binary()) -> binary() | undefined.
query(Endpoint, Query) ->
    query(Endpoint, Query, headers()).

%% @doc Execute a SPARQL query with some HTTP headers.
-spec query(url(), binary(), map()) -> list().
query(Endpoint, Query, Headers) ->
    lager:debug("sparql_client query on endpoint ~s: ~s", [Endpoint, Query]),
    Qs = z_convert:to_binary(z_url:url_encode(Query)),
    Url = <<Endpoint/binary, "?query=", Qs/binary>>,
    case ginger_http_client:get(Url, Headers) of
        undefined ->
            undefined;
        Map ->
            decode(Map)
    end.

%% @doc Get specified properties from a single resource.
-spec get_resource(url(), url(), [binary()]) -> m_rdf:rdf_resource() | undefined.
get_resource(Endpoint, Uri, Properties) ->
    {Query, Arguments} = sparql_query:select_properties(Uri, Properties),
    case query(Endpoint, Query, #{<<"Accept">> => <<"application/json">>}) of
        undefined ->
            unfined;
        %% Take the first bindings row in case multiple rows were returned because of properties
        %% with multiple values.
        #{<<"results">> := #{<<"bindings">> := [Bindings | _]}} ->
            ResolvedBindings = sparql_query:resolve_arguments(Bindings, Arguments),
            sparql_result:result_to_rdf(ResolvedBindings, Uri)
    end.

%% @doc Try to decode the response from the SPARQL endpoint.
-spec decode(map()) -> m_rdf:rdf_resource() | map().
decode(#{<<"@graph">> := _} = Data) ->
    %% Only DESCRIBE queries return JSON-LD.
    ginger_json_ld:deserialize(Data);
decode(Data) ->
    %% Other SPARQL queries return JSON.
    Data.

headers() ->
    #{<<"Accept">> => <<"application/ld+json">>}.
