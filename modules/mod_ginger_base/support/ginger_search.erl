-module(ginger_search).

-export([
    search_query/2,
    search_sql/2,
    get_unfindable_categories/1,
    withdefault/2,
    query_arguments/2
]).

-include_lib("zotonic.hrl").

-define(GINGER_SEARCH_PIVOT, ginger_search).
-define(GINGER_SEARCH_ARGUMENTS, [
    anykeyword,
    cat_exclude_defaults,
    cat_exclude_unfindable,
    cat_promote,
    cat_promote_recent,
    custompivots,
    filters,
    has_geo,
    hassubjects,
    hasobjects,
    is_findable,
    keyword,
    ongoing_on_date,
    boost_featured
]).

%% @doc Observe Zotonic search queries, transform arguments and forward to the
%%      next (second first :p) observer.
-spec search_query(#search_query{}, #context{}) -> #search_sql{} | #search_result{} | undefined.
search_query(#search_query{search = {ginger_search, Args}} = GingerQuery, Context) ->
    QueryArgs = query_arguments(Args, Context),
    ZotonicQuery = GingerQuery#search_query{search = {'query', QueryArgs}},

    %% Forward search query to the next observer. Make sure all custom Ginger
    %% search arguments have been removed.
    z_notifier:first(ZotonicQuery, Context).

%% @doc Get SQL representation of search query
-spec search_sql(#search_query{}, #context{}) -> #search_sql{}.
search_sql(#search_query{search = {ginger_search, Args}}, Context) ->
    QueryArgs = query_arguments(Args, sql_defaults(), Context),
    search_query:search(QueryArgs, Context).

%% @doc Transform custom Ginger search arguments to Zotonic search arguments.
%%      Supports all the usual query model arguments, adds default excludes.
query_arguments(GingerArguments, Context) ->
    query_arguments(GingerArguments, defaults(), Context).

query_arguments(GingerArguments, DefaultArguments, Context) ->
    RequestArgs =
        case proplists:get_value(qargs, GingerArguments) of
            true ->
                lists:filtermap(
                    fun(Arg) ->
                        case z_context:get_q(Arg, Context) of
                            undefined -> false;
                            Value -> {true, {Arg, Value}}
                        end
                    end,
                    ?GINGER_SEARCH_ARGUMENTS);
            _ ->
                []
        end,

    merge_ginger_args(lists:append(GingerArguments, RequestArgs), DefaultArguments, Context).

%% @doc Get categories marked unfindable that must be excluded from search results
-spec get_unfindable_categories(#context{}) -> list().
get_unfindable_categories(Context) ->
    Categories = z_search:query_(
        [
            {cat, category},
            {custompivot, ?GINGER_SEARCH_PIVOT},
            {filter, ["is_unfindable", true]}
        ],
        Context
    ),
    lists:map(
        fun(Category) ->
            m_rsc:p(Category, name, Context)
        end,
        Categories
    ).

%% @doc Process custom arguments and add defaults
merge_ginger_args(Args, DefaultArgs, Context) ->

    % Always set these extra query arguments
    ExtraArgs = [
        {custompivot, ?GINGER_SEARCH_PIVOT}
    ],
    MergedArgs = lists:merge(ExtraArgs, Args),

    % Associate default arguments
    MergedArgs1 = withdefault(DefaultArgs, MergedArgs),

    % Parse custom ginger_search arguments
    MergedArgs2 = lists:flatmap(
        fun(Arg) ->
            case parse_argument(Arg) of
                F when is_function(F) ->
                    F(Context);
                L when is_list(L) ->
                    L
            end
        end,
        MergedArgs1
    ),

    % Filter duplicate Args
    MergedArgs3 = remove_duplicates(MergedArgs2),
    without_custom_arguments(MergedArgs3).

% Removes duplicates but keeps order
remove_duplicates(Args) ->
    lists:reverse(lists:foldl(
        fun(Arg, Acc) ->
            case lists:member(Arg, Acc) of
                true ->
                    Acc;
                false ->
                    [Arg] ++ Acc
            end
        end,
        [],
        Args
    )).


%% @doc Strip custom Ginger search properties
-spec without_custom_arguments(list(tuple())) -> list(tuple()).
without_custom_arguments(Args) ->
    lists:filter(
        fun({Key, _Value}) ->
            not lists:member(Key, ?GINGER_SEARCH_ARGUMENTS)
        end,
        Args
    ).

%% @doc Add property to proplist if not defined
withdefault({Key, _} = Prop, Proplist) ->
    case proplists:is_defined(Key, Proplist) of
        true ->
            Proplist;
        false ->
            lists:append(Proplist, [Prop])
    end;

withdefault(Defaults, Proplist) when is_list(Defaults) ->
    lists:foldl(
        fun withdefault/2,
        Proplist,
        Defaults).

%% @doc Parse custom argument into Zotonic argument
parse_argument({_, undefined}) ->
    [];

parse_argument({Key, <<"undefined">>}) ->
    parse_argument({Key, undefined});

parse_argument({hassubjects, Subjects}) ->
    lists:map(
        fun(Subject) ->
            {hassubject, Subject}
        end,
        Subjects
    );

parse_argument({hasobjects, Objects}) ->
    lists:map(
        fun(Object) ->
            {hasobject, Object}
        end,
        Objects
    );

parse_argument({anykeyword, Keyword})
    when is_integer(Keyword); is_atom(Keyword) ->
        [{hasanyobject, [Keyword, subject]}];

parse_argument({anykeyword, Keywords}) when is_list(Keywords) ->
    [{hasanyobject, lists:map(
                        fun(Keyword) -> [Keyword, subject] end,
                        Keywords
                    )}];

parse_argument({keyword, Keyword})
    when is_integer(Keyword); is_atom(Keyword) ->
        [{hasobject, [Keyword, subject]}];

parse_argument({keyword, Keywords}) when is_list(Keywords) ->
    lists:map(
        fun(Keyword) ->
            [Prop|_] = parse_argument({keyword, Keyword}),
            Prop
        end,
        Keywords
    );

parse_argument({is_findable, Bool}) when is_boolean(Bool) ->
    [{filter, ["is_unfindable", '<>', Bool]}];

parse_argument({is_findable, Val}) ->
    parse_argument({is_findable, z_convert:to_bool(Val)});

parse_argument({cat_exclude_defaults, Bool}) when is_boolean(Bool) ->
    case Bool of
        true ->
            [{cat_exclude, [meta, media, menu, admin_content_query]}];
        false ->
            []
    end;

parse_argument({cat_exclude_defaults, Val}) ->
    parse_argument({cat_exclude_defaults, z_convert:to_bool(Val)});

parse_argument({cat_exclude_unfindable, Val}) ->
    fun(Context) ->
        case z_convert:to_bool(Val) of
            true ->
                [{cat_exclude, get_unfindable_categories(Context)}];
            false ->
                []
        end
    end;

parse_argument({cat_promote, []}) ->
    [];
parse_argument({cat_promote, Categories}) ->
    score_function(#{
        <<"filter">> => [{cat, Categories}],
        <<"weight">> => 3
    });

parse_argument({cat_promote_recent, []}) ->
    [];
parse_argument({cat_promote_recent, Categories}) ->
    score_function(#{
        <<"filter">> => [{cat, Categories}],
        <<"exp">> => #{
            <<"publication_start">> => #{
                <<"scale">> => <<"30d">>
            }
        }
    });
parse_argument({facet, Property}) when is_list(Property) ->
    parse_argument({facet, list_to_binary(Property)});
parse_argument({facet, <<"date_", _/binary>> = Property}) ->
    date_facet(Property);
parse_argument({facet, <<"publication_", _/binary>> = Property}) ->
    date_facet(Property);
parse_argument({filters, Filters}) ->
    lists:map(
        fun(Filter) ->
            % Map binaries to list to ensure filter is working
            Filter1 = lists:map(
                fun z_convert:to_list/1,
                Filter
            ),
            {filter, Filter1}
        end,
        Filters
    );

parse_argument({custompivots, []}) ->
    [];

parse_argument({custompivots, Pivots}) ->
    lists:map(
        fun(Pivot) ->
            Pivot1 = z_convert:to_atom(Pivot),
            {custompivot, Pivot1}
        end,
        Pivots
    );

parse_argument({ongoing_on_date, Date}) ->
    DayStartDT = z_datetime:prev_second(z_datetime:to_datetime(Date)),
    DayEndDT = z_datetime:next_day(DayStartDT),
    [{date_start_before, DayEndDT},
     {date_end_after, DayStartDT}];

% Filtering on undefined is supported from Zotonic 0.13.16
parse_argument({has_geo, true}) ->
    [{filter, ["pivot_location_lat", ne, undefined]},
     {filter, ["pivot_location_lng", ne, undefined]}];

parse_argument({has_geo, false}) ->
    [{filter, ["pivot_location_lat", eq, undefined]},
     {filter, ["pivot_location_lng", eq, undefined]}];

parse_argument({has_geo, Val}) ->
    parse_argument({has_geo, z_convert:to_bool(Val)});

%% @doc Increase ranking for resources for which is_featured is true.
parse_argument({boost_featured, false}) ->
    [];
parse_argument({boost_featured, true}) ->
    score_function(#{
        <<"filter">> => [{is_featured, true}],
        <<"weight">> => 2
    });

parse_argument(Arg) ->
    [Arg].

date_facet(Property) ->
    %% A facet on a date property is a min/max range.
    [
     {agg, [<<Property/binary, "_min">>, <<"min">>, [{field, Property}]]},
     {agg, [<<Property/binary, "_max">>, <<"max">>, [{field, Property}]]},
     {agg, [<<Property/binary, "_global">>,
            [
             {global, #{}},
             {aggs, #{
                      <<Property/binary, "_min">> =>
                          #{
                            <<"min">> => #{
                                           <<"field">> => Property
                                          }
                           },
                      <<Property/binary, "_max">> =>
                          #{
                            <<"max">> => #{
                                           <<"field">> => Property
                                          }
                           }
                     }}
            ]]}
    ].

%% @doc Add Elasticsearch custom score function.
score_function(Body) ->
    fun(Context) ->
        case z_module_manager:active(mod_elasticsearch, Context) of
            false ->
                %% Custom score function only works on Elasticsearch
                [];
            true ->
                [{score_function, Body}]
        end
    end.

%% @doc Default search arguments, including Elasticsearch-specific ones.
-spec defaults() -> [tuple()].
defaults() ->
    [
        {cat_exclude_unfindable, true},
        {boost_featured, true}
        | sql_defaults()
    ].

%% @doc Default search arguments that do not depend on Elasticsearch.
-spec sql_defaults() -> [tuple()].
sql_defaults() ->
    [
        {is_findable, true},
        {is_published, true},
        {cat_exclude_defaults, true}
    ].
