%% @doc JSON-LD RDF implementation
%% @author David de Boer <david@driebit.nl>
-module(ginger_json_ld).

-export([
    serialize/1,
    serialize_to_map/1,
    deserialize/1,
    open/1,
    open_file/1,
    compact/1
]).

-include("zotonic.hrl").
-include("../include/rdf.hrl").

open_file(File) ->
    {ok, Contents} = file:read_file(File),
    open(Contents).

%% @doc Deserialize JSON-LD into an RDF resource
%% @deprecated Use deserialize/1 instead.
-spec open(tuple() | list()) -> #rdf_resource{}.
open(Data) when is_map(Data) ->
    open(ginger_convert:maps_to_structs(Data));
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
    Triples2 = case create_triple_from_json(Id, Predicate, Object, Context) of
        undefined ->
            Triples;
        NewTriple ->
            Triples ++ NewTriple
    end,
    read_json(Properties, Id, Context, Triples2).

%% @doc Resolve a predicate's namespace
-spec resolve_predicate(binary(), list()) -> binary() | undefined.
resolve_predicate(<<"http://", _/binary>> = Predicate, _Context) ->
    Predicate;
resolve_predicate(<<"https://", _/binary>> = Predicate, _Context) ->
    Predicate;
resolve_predicate(<<"@type">>, _Context) ->
    <<?NS_RDF, "type">>;
resolve_predicate(Predicate, Context) ->
    case binary:split(Predicate, <<":">>) of
        [Namespace, Property] ->
            %% Predicate with namespace, e.g, "dcterms:date"
            case resolve_context_key(Namespace, Context) of
                undefined ->
                    lager:error("Namespace ~p for ~p not registered", [Namespace, Predicate]),
                    undefined;
                ResolvedNamespace ->
                    erlang:iolist_to_binary([ResolvedNamespace, Property])
            end;
        [_Property] ->
            %% Property without namespace
            case binary:split(Predicate, <<"@">>) of
                [<<"">>, _] ->
                    %% Special "@type" form
                    Predicate;
                [_] ->
                    %% Possible alias in context
                    case resolve_context_key(Predicate, Context) of
                        Uri when is_binary(Uri) ->
                            Uri;
                        #{<<"@id">> := Uri} ->
                            Uri;
                        _Something ->
                            % Fully qualified?
                            Predicate
                    end
            end
    end.

%% @doc Resolve a namespace based on the @context value
-spec resolve_context_key(binary(), list()) -> binary().
resolve_context_key(Namespace, Context) when is_map(Context) ->
    maps:get(Namespace, Context, undefined);
resolve_context_key(Namespace, Context) ->
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

object_value({struct, Props}) ->
    case proplists:get_value(<<"@id">>, Props) of
        undefined -> {literal, Props};
        Id -> {resource, Id}
    end;
object_value(Object) when is_list(Object) ->
    case z_string:is_string(Object) of
        true -> {literal, Object};
        false ->
            {TripleType, _ObjectValue} = object_value(hd(Object)),
            Values = lists:map(
                fun(ObjectItem) ->
                    {_TripleType, ObjectValue} = object_value(ObjectItem),
                    ObjectValue
                end,
                Object
            ),
            {TripleType, Values}
    end;
object_value(Object) ->
    {literal, Object}.

create_triple(Subject, Predicate, Object) ->
    {TripleType, ObjectValue} = object_value(Object),
    #triple{
        type = TripleType,
        subject = Subject,
        predicate = Predicate,
        object = ObjectValue
    }.

%% @doc Serialize an RDF resource into JSON-LD
%% @deprecated Use serialize_to_map instead.
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

%% @doc Serialize an RDF resource to a nested map (e.g. for subsequent serialization to JSON)
%% in expanded form (https://w3c.github.io/json-ld-syntax/#expanded-document-form).
serialize_to_map(#rdf_resource{id = Id, triples = Triples} = RdfResource) ->
    lists:foldl(
        fun(#triple{} = Triple, Acc) ->
            case triple_to_map(Triple, RdfResource) of
                undefined ->
                    Acc;
                TripleJson ->
                    merge_values(TripleJson, Acc)
            end
        end,
        id(Id),
        Triples
    ).

id(undefined) ->
    #{};
id(Id) ->
    #{<<"@id">> => Id}.

compact(Map) when is_map(Map) ->
    maps:fold(
        fun(Key, Value, Acc) ->
            Compacted = compact_predicate(Key),
            Acc#{Compacted => Value}
            %% TODO: add compacted predicates to @context
        end,
        #{},
        Map
    ).

compact_predicate(<<"http://purl.org/dc/elements/1.1/", Property/binary>>) ->
    <<"dce:", Property/binary>>;
compact_predicate(Predicate) ->
    binary:replace(Predicate, <<".">>, <<"_">>, [global]).

%% @doc Deserialize a JSON-LD document into an RDF resource.
-spec deserialize(tuple() | list()) -> #rdf_resource{}.
deserialize(JsonLd) when is_map(JsonLd) ->
    Context = maps:get(<<"@context">>, JsonLd, #{}),
    maps:fold(
        fun(Key, Value, Acc) ->
            deserialize(Key, Value, Acc, Context)
        end,
        #rdf_resource{},
        maps:remove(<<"@context">>, JsonLd)
    );
deserialize(JsonLd) ->
    %% Fall back to mochijson {struct, ...} structure
    open(JsonLd).

deserialize(<<"@id">>, Uri, #rdf_resource{} = Acc, _Context) ->
    Acc#rdf_resource{id = Uri};
deserialize(Predicate, #{<<"@id">> := Uri}, #rdf_resource{} = Acc, Context) ->
    deserialize(Predicate, Uri, Acc, Context);
deserialize(<<"@graph">>, Triples, #rdf_resource{triples = ParentTriples} = Acc, _Context) ->
    AllTriples = lists:foldl(
        fun(#{<<"@id">> := _Subject} = Map, ParentAcc) ->
            #rdf_resource{triples = GraphTriples} = deserialize(Map),
            lists:merge(GraphTriples, ParentAcc)
        end,
        ParentTriples,
        Triples
    ),
    Acc#rdf_resource{triples = AllTriples};
deserialize(Predicate, Objects, #rdf_resource{id = Subject, triples = Triples} = Acc, Context) ->
    NewTriples = [triple(Subject, resolve_predicate(Predicate, Context), Object) || Object <- list(Objects)],
    Acc#rdf_resource{triples = Triples ++ NewTriples}.

list(Object) when is_list(Object) ->
    Object;
list(Object) ->
    [Object].

%% @doc Construct a #triple{} record.
-spec triple(binary(), binary(), binary()) -> #triple{}.
triple(Subject, Predicate, <<"http://", _/binary>> = Object) ->
    #triple{type = resource, subject = Subject, predicate = Predicate, object = Object};
triple(Subject, Predicate, <<"https://", _/binary>> = Object)  ->
    #triple{type = resource, subject = Subject, predicate = Predicate, object = Object};
triple(Subject, Predicate, #{<<"@id">> := Uri} = Map) ->
    case length(maps:keys(Map)) of
        1 ->
            %% Only an @id element, so a reference to a URI.
            #triple{type = resource, subject = Subject, predicate = Predicate, object = Uri};
        _ ->
            %% A nested resource including an @id element and other predicates.
            Triples = maps:fold(
                fun(NestedPred, NestedObject, Acc) ->
                    Acc ++ [triple(Uri, NestedPred, NestedObject)]
                end,
                [],
                Map
            ),
            NestedResource = #rdf_resource{
                id = Uri,
                triples = Triples
            },
            #triple{type = resource, subject = Subject, predicate = Predicate, object = NestedResource}
    end;
triple(Subject, Predicate, #{<<"@language">> := Language, <<"@value">> := Value}) ->
    Object = #rdf_value{value = Value, language = Language},
    #triple{subject = Subject, predicate = Predicate, object = Object};
triple(Subject, Predicate, #{<<"@value">> := Value}) ->
    Object = #rdf_value{value = Value},
    #triple{subject = Subject, predicate = Predicate, object = Object};
triple(Subject, Predicate, Object) ->
    #triple{subject = Subject, predicate = Predicate, object = Object}.

triple_to_json(#triple{predicate = <<?NS_RDF, "type">>, type = resource, object = Object}) ->
    {<<"@type">>, Object};
triple_to_json(#triple{type = literal, predicate = Predicate, object = Object}) ->
    %% z_convert:to_json to convert any date tuples to datetime string, which
    %% doesn't work if we pass {struct, Data} (see comment above).
    {Predicate, z_convert:to_json(Object)};
triple_to_json(#triple{type = resource, predicate = Predicate, object = Object}) ->
    {Predicate, [{<<"@id">>, Object}]}.

triple_to_map(#triple{object = #rdf_value{value = undefined}}, #rdf_resource{}) ->
    %% Ignore empty triples without object.
    undefined;
triple_to_map(#triple{subject = Id, predicate = <<?NS_RDF, "type">>, object = Object}, #rdf_resource{id = Id}) when is_binary(Object) ->
    #{<<"@type">> => [Object]};
triple_to_map(#triple{subject = Id, predicate = Predicate, object = #rdf_value{value = Object, language = undefined}}, #rdf_resource{id = Id}) ->
    #{Predicate => [#{<<"@value">> => Object}]};
triple_to_map(#triple{subject = Id, predicate = Predicate, object = #rdf_value{value = Object, language = Lang}}, #rdf_resource{id = Id}) ->
    #{Predicate => [#{<<"@value">> => Object, <<"@language">> => Lang}]};
triple_to_map(#triple{predicate = Predicate, object = #rdf_resource{} = Object}, #rdf_resource{}) ->
    %% Embedded objects.
    #{Predicate => [serialize_to_map(Object)]};
triple_to_map(#triple{subject = Id, predicate = Predicate, object = Object}, #rdf_resource{id = Id} = RdfResource) ->
    %% Nest values from referenced objects.
    #{Predicate => [merge_triples(RdfResource, Object)]};
triple_to_map(#triple{}, #rdf_resource{}) ->
    %% Ignore triples that belong to other subjects (they are found through the
    %% recursive call in the clause above).
    undefined.

%% @doc Nest values from referenced resources.
merge_triples(#rdf_resource{id = Subject}, Subject) ->
    %% Prevent infinite recursion when subject references itself.
    Subject;
merge_triples(#rdf_resource{} = RdfResource, Subject) ->
    lists:foldl(
        fun(#triple{} = Triple, Map) ->
            %% Replace id in RDF resource with that of the current object
            merge_values(triple_to_map(Triple, RdfResource#rdf_resource{id = Subject}), Map)
        end,
        #{<<"@id">> => Subject},
        m_rdf:filter_subject(RdfResource, Subject)
    ).

%% @doc Merge a key/value map into an accumulator map, combining multiple
%% values for the same key.
-spec merge_values(map(), map()) -> map().
merge_values(KeyValue, Acc) ->
    %% Read current key from KeyValue pair
    Key = hd(maps:keys(KeyValue)),
    #{Key := NewValue} = KeyValue,

    case maps:get(Key, Acc, undefined) of
        undefined ->
            maps:merge(Acc, KeyValue);
        Value ->
            Acc#{Key => Value ++ NewValue}
    end.
