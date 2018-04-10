%% @doc Convert SPARQL JSON results to RDF.
-module(sparql_result).

-export([
    result_to_rdf/2
]).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

%% @doc Convert SPARQL result to an RDF resource.
-spec result_to_rdf(map(), binary()) -> #rdf_resource{}.
result_to_rdf(Bindings, Uri) ->
    Triples = maps:fold(
        fun(Predicate, Data, Acc) ->
            [triple(Predicate, Data) | Acc]
        end,
        [],
        Bindings
    ),
    #rdf_resource{
        id = Uri,
        triples = Triples
    }.

%% @doc Convert a SPARQL binding to RDF #triple{}.
-spec triple(binary(), any()) -> #triple{}.
triple(Predicate, #{<<"type">> := <<"literal">>, <<"value">> := Value, <<"xml:lang">> := Language}) ->
    #triple{
        predicate = Predicate,
        object = #rdf_value{value = Value, language = Language}
    };
triple(Predicate, #{<<"type">> := <<"literal">>, <<"value">> := Value}) ->
    #triple{
        predicate = Predicate,
        object = #rdf_value{value = Value}
    };
triple(Predicate, #{<<"type">> := <<"typed-literal">>, <<"value">> := Value}) ->
    #triple{
        predicate = Predicate,
        object = #rdf_value{value = Value}
    };
triple(Predicate, #{<<"type">> := <<"uri">>, <<"value">> := Value}) ->
    #triple{
        type = resource,
        predicate = Predicate,
        object = Value
    }.
