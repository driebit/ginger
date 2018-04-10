%% @doc Build SPARQL queries.
-module(sparql_query).

-export([
    select_properties/2,
    resolve_arguments/2
]).

-include_lib("zotonic.hrl").

-type arguments() :: proplists:proplist().

%% @doc Get some properties from a SPARQL resource.
-spec select_properties(binary(), [binary()]) -> {binary(), arguments()}.
select_properties(Uri, Properties) ->
    {Where, Arguments} = where(Properties),
    Query = <<"select * {
        VALUES ?s {<", Uri/binary, ">}",
        (iolist_to_binary(Where))/binary,
    " }">>,
    {Query, Arguments}.

%% @doc Resolve query arguments by replacing numerical placeholders with their
%%      LD predicate counterparts stored in Arguments.
-spec resolve_arguments(Bindings :: map(), arguments()) -> Bindings :: map().
resolve_arguments(Bindings, Arguments) ->
    maps:fold(
        fun(Key, Value, Acc) ->
            ResolvedKey = proplists:get_value(Key, Arguments),
            Acc#{ResolvedKey => Value}
        end,
        #{},
        Bindings
    ).

%% @doc Build a where query section.
-spec where([binary()]) -> {[binary()], [binary()]}.
where(Properties) ->
    lists:mapfoldl(
        fun add_argument/2,
        [],
        Properties
    ).

%% @doc Add a single property argument.
-spec add_argument(binary(), arguments()) -> {Query :: binary(), arguments()}.
add_argument(Property, Properties) ->
    Next = z_convert:to_binary(length(Properties) + 1),
    {<<"OPTIONAL {?s <", Property/binary, "> ?", Next/binary, "} ">>, Properties ++ [{Next, Property}]}.
