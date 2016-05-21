%% @doc JSON-LD RDF implementation
%% @author David de Boer <david@driebit.nl>
-module(ginger_json_ld).

-export([
    serialize/1,
    deserialize/1,
    open/1,
    open_file/1
]).

-include("zotonic.hrl").
-include("../include/rdf.hrl").

open_file(File) ->
    {ok, Contents} = file:read_file(File),
    open(Contents).

%% @doc Deserialize JSON-LD into an RDF resource
%%      This function has been renamed to deserialize() and is here for BC.
-spec open(tuple() | list()) -> #rdf_resource{}.
open({struct, _Item} = Data) ->
    {_Context, Id, Triples} = read_json(Data),
    #rdf_resource{id = Id, triples = Triples};
open(Json) ->
    Data = mochijson2:decode(Json),
    {_Context, Id, Triples} = read_json(Data),
    #rdf_resource{id = Id, triples = Triples}.

read_json({struct, Json}) when is_list(Json) ->
    %% Read @context
    Context = case proplists:get_value(<<"@context">>, Json) of
        {struct, Namespaces} -> Namespaces;
        undefined -> []
    end,

    Id = proplists:get_value(<<"@id">>, Json),
    Properties = proplists:delete(<<"@id">>,
        proplists:delete(<<"@context">>, Json)
    ),

    %% Read all properties, including @graph
    read_json(Properties, Id, Context, []).

read_json([], Id, Context, Triples) ->
    {Context, Id, Triples};
read_json({<<"@graph">>, []}, Id, Context, Triples) ->
    {Context, Id, Triples};
read_json({<<"@graph">>, [{struct, Props}|Rest]}, _Id, Context, Triples) ->
    GraphTriples = read_graph(Props, Context),
    read_json({<<"@graph">>, Rest}, _Id, Context, GraphTriples ++ Triples);
read_json([{Predicate, Object}|Properties], Id, Context, Triples) ->
    NewTriple = create_triple_from_json(Id, Predicate, Object, Context),
    Triples2 = Triples ++ NewTriple,
    read_json(Properties, Id, Context, Triples2).

%% @doc Resolve a predicate's namespace
-spec resolve_predicate(binary(), list()) -> binary() | undefined.
resolve_predicate(Predicate, Context) ->
    case binary:split(Predicate, <<":">>) of
        [Namespace, Property] ->
            %% Predicate with namespace, e.g, "dcterms:date"
            case resolve_namespace(Namespace, Context) of
                undefined ->
                    lager:error("Namespace ~p not registered", [Namespace]),
                    undefined;
                ResolvedNamespace ->
                    erlang:iolist_to_binary([ResolvedNamespace, Property])
            end;
        [Property] ->
            %% Special property without namespace, e.g., "@type"
            Property
    end.

%% @doc Resolve a namespace based on the @context value
-spec resolve_namespace(binary(), list()) -> binary().
resolve_namespace(Namespace, Context) ->
    proplists:get_value(Namespace, Context).

create_triple_from_json(Subject, Predicate, Object, Context) ->
    case resolve_predicate(Predicate, Context) of
        undefined ->
            undefined;
        ResolvedPredicate ->
            [create_triple(Subject, ResolvedPredicate, Object)]
    end.

read_graph(Props, Context) ->
    Id = proplists:get_value(<<"@id">>, Props),
    _Type = proplists:get_value(<<"@type">>, Props),
    PropsList = proplists:delete(
        <<"@id">>,
        proplists:delete(
            <<"@type">>,
            Props
        )
    ),
    lists:foldl(
        fun({Predicate, Object}, Triples) ->
            case resolve_predicate(Predicate, Context) of
                undefined ->
                    Triples;
                ResolvedPredicate ->
                    Triples ++ [create_triple(Id, ResolvedPredicate, Object)]
            end
        end,
        [],
        PropsList
    ).

create_triple(Subject, Predicate, {struct, [{<<"@id">>, Id}]}) ->
    #triple{
        type = resource,
        subject = Subject,
        predicate = Predicate,
        object = Id
    };
create_triple(Subject, Predicate, Object) ->
    #triple{
        type = literal,
        subject = Subject,
        predicate = Predicate,
        object = Object
    }.


%% @doc Serialize an RDF resource into JSON-LD
-spec serialize(#rdf_resource{}) -> list().
serialize(#rdf_resource{id = Id, triples = Triples}) ->
    Data = lists:reverse(lists:foldl(
        fun(#triple{} = Triple, Acc) ->
            {JsonKey, JsonValue} = TripleJson = triple_to_json(Triple),
            case proplists:get_value(JsonKey, Acc) of
                undefined ->
                    %% Add new JSON triple element to Acc
                    [TripleJson | Acc];
                Value = [List] when not is_list(List) ->
                    %% [{<<"@id">>, <<"http://...>>"}]
                    [{JsonKey, [JsonValue | [Value]]} | proplists:delete(JsonKey, Acc)];
                Value ->
                    %% [[{<<"@id">>, <<"http://...>>"}], [{<<"@id">>, <<"http://...>>"}]]
                    [{JsonKey, [JsonValue | Value]} | proplists:delete(JsonKey, Acc)]
            end
        end,
        [{<<"@id">>, Id}],
        Triples
    )),

    %% We need to add a {struct, ...} tuple here so z_convert:to_json/1 won't
    %% prefix the data with an {array, ...} tuple.
    %% See https://github.com/zotonic/z_stdlib/pull/14
    z_convert:to_json({struct, Data}).

-spec deserialize(tuple() | list()) -> #rdf_resource{}.
deserialize(JsonLd) ->
    open(JsonLd).

triple_to_json(#triple{predicate = <<?NS_RDF, "type">>, type = resource, object = Object}) ->
    {<<"@type">>, Object};
triple_to_json(#triple{type = literal, predicate = Predicate, object = Object}) ->
    %% z_convert:to_json to convert any date tuples to datetime string, which
    %% doesn't work if we pass {struct, Data} (see comment above).
    {Predicate, z_convert:to_json(Object)};
triple_to_json(#triple{type = resource, predicate = Predicate, object = Object}) ->
    {Predicate, [{<<"@id">>, Object}]}.
