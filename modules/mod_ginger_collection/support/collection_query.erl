%% @doc Collection search query
-module(collection_query).

-export([
    is_collection_query/1,
    parse_query/3
]).

-include_lib("zotonic.hrl").
-include_lib("mod_ginger_rdf/include/rdf.hrl").

%% @doc Does the search query include collection objects?
-spec is_collection_query(proplists:proplist()) -> boolean().
is_collection_query(Args) ->
    proplists:get_value(collection, Args, false).

%% @doc Parse Zotonic search query arguments and return Elastic query arguments.
-spec parse_query(list() | binary(), binary(), proplists:proplist()) -> proplists:proplist().
parse_query(Key, Value, QueryArgs) when is_list(Key) ->
    parse_query(list_to_binary(Key), Value, QueryArgs);
parse_query(_Key, [], QueryArgs) ->
    QueryArgs;
parse_query(_Key, <<>>, QueryArgs) ->
    QueryArgs;
parse_query(<<"facets">>, Facets, QueryArgs) ->
    QueryArgs ++ lists:map(fun map_facet/1, Facets);
parse_query(<<"subject">>, Subjects, QueryArgs) ->
    QueryArgs ++ lists:map(
        fun(Subject) ->
            {filter, [<<"dcterms:subject.rdfs:label.keyword">>, Subject]}
        end,
        Subjects
    );
%% Whitelist term filters
parse_query(Term, Values, QueryArgs) when
    % used in Erfgoed Brabant
    Term =:= <<"category.keyword">>;
    Term =:= <<"dc:type.keyword">>;
    Term =:= <<"nave:collection.keyword">>;
    Term =:= <<"nave:collectionPart.keyword">>;
    Term =:= <<"address_city.keyword">>;
    Term =:= <<"dc:creator.keyword">>;
    Term =:= <<"dc:subject.keyword">>;
    Term =:= <<"dcterms:medium.keyword">>;
    Term =:= <<"nave:technique.keyword">>;
    % other usages
    Term =:= <<"object_category.keyword">>;
    Term =:= <<"dcterms:spatial.rdfs:label.keyword">>;
    Term =:= <<"dcterms:subject.rdfs:label.keyword">>;
    Term =:= <<"rdf:type.rdfs:label.keyword">>
->
    QueryArgs ++ lists:map(
        fun(Value) ->
            {filter, [Term, Value]}
        end,
        Values
    );
parse_query(Term, Values, QueryArgs) when Term =:= <<"dcterms:creator.rdfs:label.keyword">> ->
    %% Nested query term creator is an OR
    QueryArgs ++ [{filter, [[Term, Value, #{<<"path">> => <<"dcterms:creator">>}] || Value <- Values]}];
%% Parse subsets (Elasticsearch types). You can specify multiple per checkbox
%% by separating them with a comma.
parse_query(<<"subset">>, Types, QueryArgs) ->
    AllTypes = lists:foldl(
        fun(Type, Acc) ->
            Acc ++ binary:split(Type, <<",">>, [global])
        end,
        [],
        Types
    ),
    QueryArgs ++ [{filter, [[<<"_type">>, Type] || Type <- AllTypes]}];
parse_query(Key, Range, QueryArgs) when Key =:= <<"dcterms:date">>; Key =:= <<"dcterms:created">>; Key =:= <<"date_start">> ->
    IncludeMissing = proplists:get_value(<<"include_missing">>, Range, false),
    QueryArgs
        ++ date_filter(Key, <<"gte">>, proplists:get_value(<<"min">>, Range), IncludeMissing)
        ++ date_filter(Key, <<"lte">>, proplists:get_value(<<"max">>, Range), IncludeMissing);
parse_query(<<"edge">>, Edges, QueryArgs) ->
    QueryArgs ++ lists:foldl(
        fun(Edge, Acc) ->
            [Acc | map_edge(Edge)]
        end,
        [],
        Edges
    );
parse_query(
    related_to, #{
        <<"_id">> := Id,
        <<"_type">> := Type,
        <<"_source">> := Source
    },
    QueryArgs
) ->
    OrFilters = map_related_to(Source),
    %% Use query_context_filter to have them scored: more matching edges mean
    %% a better matching document.
    [{query_context_filter, OrFilters}, {exclude_document, [Type, Id]} | QueryArgs];
parse_query(related_to, RscRdf, QueryArgs) when is_map(RscRdf)->
    OrFilters = map_related_to(RscRdf),
    [{query_context_filter, [[<<"_type">>, <<"resource">>] | OrFilters]} | QueryArgs];

parse_query(<<"license">>, Values, QueryArgs) ->
    QueryArgs ++ [{filter, [[<<"dcterms:license.keyword">>, Value] || Value <- Values]}];
parse_query(is_published, Value, QueryArgs) ->
    %% Resource is published OR it's not a Zotonic resource
    QueryArgs ++ [{filter, [[<<"is_published">>, Value], [<<"_type">>, '<>', <<"resource">>]]}];
parse_query(Key, Value, QueryArgs) ->
    [{Key, Value} | QueryArgs].

map_facet({Name, [{<<"global">>, Props}]}) ->
    %% Nested global aggregation
    {agg, [Name, Props ++ [{<<"global">>, [{}]}]]};
map_facet({Name, [{Type, Props}]}) when is_list(Props) ->
    {agg, [Name, Type, Props]};
map_facet({Name, Props}) ->
    {agg, [Name, Props]}.

map_edge(<<"depiction">>) ->
    [
        {hasanyobject, [[<<"*">>, <<"depiction">>]]},
        {filter, [[<<"reproduction.value">>, exists], [<<"http://www_europeana_eu/schemas/edm/isShownBy.@id">>, exists], [<<"_type">>, <<"resource">>]]}
    ];

map_edge(_) ->
    [].

map_related_to(Object) when is_map(Object) ->
    ObjectWithContext = Object#{<<"@context">> => #{
        <<"schema">> => ?NS_SCHEMA_ORG,
        <<"dcterms">> => ?NS_DCTERMS,
        <<"dbpedia-owl">> => ?NS_DBPEDIA_OWL,
        <<"dbo">> => ?NS_DBPEDIA_OWL,
        <<"foaf">> => ?NS_FOAF,
        <<"rdf">> => ?NS_RDF
    }},
    #rdf_resource{triples = Triples} = ginger_json_ld:deserialize(ObjectWithContext),
    lists:foldl(fun map_related_to_property/2, [], Triples).

map_related_to_property(#triple{predicate = <<?NS_RDF, "type">>, type = resource, object = Object}, Filters) ->
    [
        [<<"rdf:type.@id.keyword">>, Object],
        [<<"dcterms:subject.@id.keyword">>, Object]
        | Filters
    ];
map_related_to_property(#triple{predicate = <<?NS_DCTERMS, "creator">>, type = resource, object = Object}, Filters) ->
    [[<<"dcterms:creator.@id.keyword">>, '=', Object, #{<<"path">> => <<"dcterms:creator">>}] | Filters];
map_related_to_property(#triple{predicate = <<?NS_DCTERMS, "subject">>, type = resource, object = Object}, Filters) ->
    [[<<"dcterms:subject.@id.keyword">>, Object] | Filters];
map_related_to_property(#triple{predicate = <<?NS_DCTERMS, "spatial">>, type = resource, object = Object}, Filters) ->
    [[<<"dcterms:spatial.@id.keyword">>, Object] | Filters];
map_related_to_property(#triple{predicate = <<"http://purl.org/dc/elements/1.1/subject">>, object = #rdf_value{value = Literal}}, Filters) ->
    [[<<"dc:subject.keyword">>, Literal] | Filters];
map_related_to_property(#triple{}, QueryArgs) ->
    QueryArgs.

date_filter(_Key, _Operator, <<>>, _IncludeMissing) ->
    [];
date_filter(Key, Operator, Value, IncludeMissing) when Operator =:= <<"gte">>; Operator =:= <<"gt">>;
    Operator =:= <<"lte">>; Operator =:= <<"lt">>
->
    DateFilter = [Key, Operator, Value, [{<<"format">>, <<"yyyy">>}]],
    OrFilters = case IncludeMissing of
        true ->
            [DateFilter, [Key, missing]];
        false ->
            DateFilter
    end,

    [{filter, OrFilters}].
