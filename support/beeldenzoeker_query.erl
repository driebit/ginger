%% @doc Beeldenzoeker search query
-module(beeldenzoeker_query).

-export([
    parse_query/3
]).

-include_lib("zotonic.hrl").

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
            {filter, [<<"association.subject.keyword">>, Subject]}
        end,
        Subjects
    );
parse_query(<<"subset">>, [<<"collection">>, <<"event">>], QueryArgs) ->
    %% don't filter
    QueryArgs;
parse_query(<<"subset">>, [<<"collection">>], QueryArgs) ->
    QueryArgs ++ [{filter, [<<"association.subject.keyword">>, '<>', <<"evenement">>]}];
parse_query(<<"subset">>, [<<"event">>], QueryArgs) ->
    QueryArgs ++ [{filter, [<<"association.subject.keyword">>, <<"evenement">>]}];
parse_query(<<"period">>, Period, QueryArgs) ->
    QueryArgs2 = case proplists:get_value(<<"min">>, Period) of
        <<>> ->
            QueryArgs;
        Min ->
            QueryArgs ++ [{filter, [<<"dcterms:date">>, <<"gte">>, Min]}]
    end,
    case proplists:get_value(<<"max">>, Period) of
        <<>> ->
            QueryArgs2;
        Max ->
            QueryArgs2 ++ [{filter, [<<"dcterms:date">>, <<"lte">>, Max]}]
    end;
parse_query(_Key, _Value, QueryArgs) ->
    QueryArgs.

map_facet({Name, [{Type, Props}]}) ->
    {agg, [Name, Type, Props]};
map_facet({Name, Props}) ->
    map_facet({Name, [{terms, Props}]}).
