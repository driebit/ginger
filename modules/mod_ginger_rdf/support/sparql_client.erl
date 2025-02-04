%% @doc A basic SPARQL client.
-module(sparql_client).

-export([
    describe/2,
    query/2,
    query/3,
    query_rdf/2,
    query_rdf/3,
    get_resource/3,
    get_resource/4
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
            lists:map(
                fun(#{<<"s">> := #{<<"value">> := Uri}} = Binding) ->
                    ResolvedBindings = sparql_query:resolve_arguments(Binding, Query),
                    sparql_result:result_to_rdf(ResolvedBindings, Uri)
                end,
                Bindings
            )
    end.

%% @doc Get specified properties from a single resource.
-spec get_resource(url(), url(), [binary()]) -> m_rdf:rdf_resource() | undefined.
get_resource(Endpoint, Uri, Properties) ->
    get_resource(Endpoint, Uri, Properties, undefined).

-spec get_resource(Endpoint, Uri, Properties, Language) -> RdfResource | undefined when
    Endpoint :: url(),
    Uri :: url(),
    Properties :: [binary()],
    Language :: binary | undefined,
    RdfResource :: m_rdf:rdf_resource().
get_resource(Endpoint, Uri, Properties, Language) ->
    Query = sparql_query:select(Uri, Properties),
    case query_rdf(Endpoint, Query) of
        undefined ->
            undefined;
        [] ->
            undefined;
        Rows ->
            % Multiple results, group by language
            Languages = [ Language | lists:usort(value_languages(Rows, [])) ],
            Languages1 = lists:filter(fun is_binary/1, Languages),
            LangPrefs = if
                Language =:= undefined -> lang_prefs();
                true -> [ Language | lang_prefs() ]
            end,
            first_matching(Languages1, Rows, LangPrefs)
    end.

first_matching([], Rows, _Prefs) ->
    hd(Rows);
first_matching([Lang|_], Rows, []) ->
    extract_language(Lang, Rows);
first_matching(Langs, Rows, [ Pref | Prefs]) ->
    case lists:member(Pref, Langs) of
        true -> extract_language(Pref, Rows);
        false -> first_matching(Langs, Rows, Prefs)
    end.

lang_prefs() ->
    [ <<"nl">>, <<"en">>, <<"de">>, <<"fr">> ].

extract_language(Lang, [ #rdf_resource{ triples = RTs} = R | _ ] = Rows) ->
    AllTriples = [ Ts || #rdf_resource{ triples = Ts } <- Rows ],
    TripleCount = length(RTs),
    Accs = [ [] || _ <- lists:seq(1, TripleCount) ],
    PerTriple = lists:map(fun lists:reverse/1, rotate(AllTriples, Accs)),
    ForLang = lists:map(
        fun(Ts) ->
            case first_matching(Lang, Ts) of
                undefined ->
                    case first_matching(<<"en">>, Ts) of
                        undefined -> hd(Ts);
                        T -> T
                    end;
                T ->
                    T
            end
        end,
        PerTriple),
    R#rdf_resource{
        triples = ForLang
    }.

first_matching(_Lang, []) ->
    undefined;
first_matching(Lang, [ #triple{ object = #rdf_value{ language = ObjLang } } = T | _ ]) when Lang =:= ObjLang ->
    T;
first_matching(Lang, [ #triple{ object = #rdf_value{ language = _ } } | Ts ]) ->
    first_matching(Lang, Ts);
first_matching(_Lang, [ T | _ ]) ->
    T.

rotate([], Accs) ->
    Accs;
rotate([R|Rs], Accs) ->
    Accs1 = append_to_accs(R, Accs, []),
    rotate(Rs, Accs1).

append_to_accs([], [], NewAccs) ->
    lists:reverse(NewAccs);
append_to_accs([Col|Cols], [Acc|Accs], NewAccs) ->
    NewAccs1 = [ [ Col | Acc ] | NewAccs ],
    append_to_accs(Cols, Accs, NewAccs1).


value_languages(#rdf_resource{ triples = Ts }, Acc) ->
    value_languages(Ts, Acc);
value_languages(#triple{ object = #rdf_value{ language = Lang }}, Acc) ->
    [Lang | Acc];
value_languages([T|Ts], Acc) ->
    Acc1 = value_languages(T, Acc),
    value_languages(Ts, Acc1);
value_languages(_, Acc) ->
    Acc.


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
