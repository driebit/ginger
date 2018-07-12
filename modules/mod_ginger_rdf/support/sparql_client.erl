%% @doc A basic SPARQL client.
-module(sparql_client).

-export([
    describe/2,
    query/2,
    query/3,
    query_rdf/2,
    query_rdf/3,
    get_resource/3
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-export_type([
    url/0,
    query/0
]).

-type url() :: binary().
-type query() :: sparql_query:sparql_query() | binary().

%% @doc Describe a single resource
-spec describe(url(), url()) -> m_rdf:rdf_resource() | undefined.
describe(Endpoint, <<"https://", _/binary>> = Uri) ->
    describe(Endpoint, <<"<", Uri/binary, ">">>);
describe(Endpoint, <<"http://", _/binary>> = Uri) ->
    describe(Endpoint, <<"<", Uri/binary, ">">>);
describe(Endpoint, Clause) ->
    query(Endpoint, (<<"DESCRIBE ", Clause/binary>>), #{<<"Accept">> => <<"application/json">>}).

%% @doc Execute a SPARQL query.
-spec query(url(), query()) -> binary() | undefined.
query(Endpoint, Query) ->
    query(Endpoint, Query, headers()).

%% @doc Execute a SPARQL query with some HTTP headers.
-spec query(url(), query(), map()) -> map().
query(Endpoint, Query, Headers) when is_binary(Query) ->
    lager:debug("sparql_client query on endpoint ~s: ~s", [Endpoint, Query]),
    Qs = z_convert:to_binary(z_url:url_encode(Query)),
    Url = <<Endpoint/binary, "?query=", Qs/binary>>,
    case ginger_http_client:get(Url, Headers) of
        undefined ->
            undefined;
        Map ->
            decode(Map)
    end;
query(Endpoint, Query, Headers) ->
    query(Endpoint, sparql_query:query(Query), Headers).

%% @doc Execute query and return result as RDF.
-spec query_rdf(ginger_uri:uri(), query()) -> [m_rdf:rdf_resource()].
query_rdf(Endpoint, Query) ->
    query_rdf(Endpoint, Query, headers()).

%% @doc Execute query and return result as RDF.
-spec query_rdf(ginger_uri:uri(), query(), map()) -> [m_rdf:rdf_resource()].
query_rdf(Endpoint, Query, Headers) ->
    case query(Endpoint, Query, Headers) of
        undefined ->
            undefined;
        #{<<"results">> := #{<<"bindings">> := Bindings}} ->
            %% Result set can have multiple rows with same ?s (subject URI), so combine those into
            %% RDF resources.
            RdfResources = lists:map(
                fun(#{<<"s">> := #{<<"value">> := Uri}} = Binding) ->
                    ResolvedBindings = sparql_query:resolve_arguments(Binding, Query),
                    sparql_result:result_to_rdf(ResolvedBindings, Uri)
                end,
                Bindings
            ),
            m_rdf:merge(RdfResources)
    end.

%% @doc Get specified properties from a single resource.
-spec get_resource(url(), url(), [binary()]) -> m_rdf:rdf_resource() | undefined.
get_resource(Endpoint, Uri, Properties) ->
    Query = sparql_query:select(Uri, Properties),
    case query_rdf(Endpoint, Query) of
        undefined ->
            undefined;
        [Rdf] ->
            Rdf
    end.

%% @doc Try to decode the response from the SPARQL endpoint.
-spec decode(map()) -> m_rdf:rdf_resource() | map().
decode(#{<<"@graph">> := _} = Data) ->
    %% Only DESCRIBE and CONSTRUCT queries return JSON-LD.
    ginger_json_ld:deserialize(Data);
decode(Data) ->
    %% Other SPARQL queries return JSON.
    Data.

headers() ->
    #{<<"Accept">> => <<"application/json">>}.
