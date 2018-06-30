%% @doc Build SPARQL queries.
-module(sparql_query).

-export([
    select/1,
    select_properties/2,
    resolve_arguments/2,
    and_where/2,
    limit/2,
    offset/2,
    query/1
]).

-include_lib("zotonic.hrl").

-type arguments() :: proplists:proplist().
-type query() :: binary().

-record(sparql_query, {
    select = [] :: [binary()],
    where = [] :: [binary()],
    arguments = [] :: arguments(),
    offset = 0 :: non_neg_integer(),
    limit = 1000 :: pos_integer()
}).

-opaque sparql_query() :: #sparql_query{}.

-export_type([
    sparql_query/0,
    query/0
]).

%% @doc Construct textual SPARQL query.
-spec query(sparql_query()) -> binary().
query(#sparql_query{select = Selects, where = Where, offset = Offset, limit = Limit}) ->
    <<
        "SELECT ", (ginger_binary:join(Selects, <<" ">>))/binary,
        " { ", (ginger_binary:join(Where, <<" ">>))/binary, " } ",
        " OFFSET ", (integer_to_binary(Offset))/binary,
        " LIMIT ", (integer_to_binary(Limit))/binary
    >>.

%% @doc Construct a SPARQL query with a selection of predicates.
-spec select([binary()]) -> sparql_query().
select(Predicates) ->
    Query = where(Predicates),
    Query#sparql_query{select = [<<"*">>]}.

%% @doc Get some properties from a SPARQL resource.
-spec select_properties(binary(), [binary()]) -> sparql_query().
select_properties(Uri, Predicates) ->
    Query = select(Predicates),
    and_where(<<"VALUES ?s {<", Uri/binary, ">}">>, Query).

%% @doc Resolve query arguments by replacing numerical placeholders with their
%%      LD predicate counterparts stored in Arguments.
-spec resolve_arguments(Bindings :: map(), sparql_query()) -> Bindings :: map().
resolve_arguments(Bindings, #sparql_query{arguments = Arguments}) ->
    maps:fold(
        fun(Key, Value, Acc) ->
            case proplists:get_value(Key, Arguments) of
                undefined ->
                    Acc;
                ResolvedKey ->
                    Acc#{ResolvedKey => Value}
            end
        end,
        #{},
        Bindings
    ).

%% @doc Add a where clause to a query.
-spec and_where(binary(), sparql_query()) -> sparql_query().
and_where(Clause, #sparql_query{where = Clauses} = Query) ->
    Query#sparql_query{where = [Clause | Clauses]}.

%% @doc Add offset to query.
-spec offset(non_neg_integer(), sparql_query()) -> sparql_query().
offset(Offset, Query) when Offset >= 0 ->
    Query#sparql_query{offset = Offset}.

%% @doc Add limit to query.
-spec limit(pos_integer(), sparql_query()) -> sparql_query().
limit(Limit, Query) when Limit > 0 ->
    Query#sparql_query{limit = Limit}.

%% @doc Build a where query section.
-spec where([binary()]) -> #sparql_query{}.
where(Properties) ->
    {Where, Arguments} = lists:mapfoldl(
        fun add_argument/2,
        [],
        Properties
    ),
    #sparql_query{where = Where, arguments = Arguments}.

%% @doc Add a single property argument.
-spec add_argument(binary(), arguments()) -> {Query :: binary(), arguments()}.
add_argument(Property, Properties) ->
    Next = z_convert:to_binary(length(Properties) + 1),
    {<<"OPTIONAL {?s <", Property/binary, "> ?", Next/binary, "}">>, Properties ++ [{Next, Property}]}.
