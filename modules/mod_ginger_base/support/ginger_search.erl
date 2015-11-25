-module(ginger_search).

-export([
    search_query/2,
    get_unfindable_categories/1,
    merge_ginger_args/2
]).

-include_lib("zotonic.hrl").

-define(GINGER_SEARCH_PIVOT, ginger_search).

%% @doc Supports all the usual query model arguments, adds default excludes.
search_query(#search_query{search={ginger_search, Args}}, Context) ->
    QueryArgs = merge_ginger_args(Args, Context),
    search_query:search(QueryArgs, Context).

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
parse_argument({keyword, Keyword}, _Context)
    when is_integer(Keyword); is_atom(Keyword) ->
        [{hasobject, [Keyword, subject]}];

parse_argument({keyword, Keywords}, Context) when is_list(Keywords) ->
    lists:map(
        fun(Keyword) ->
            [Prop|_] = parse_argument({keyword, Keyword}, Context),
            Prop
        end,
        Keywords
    );

parse_argument({is_findable, Bool}, _Context) when is_boolean(Bool) ->
    % TODO: Filter all resources within category if it is unfindable
    Is_unfindable = not Bool,
    [{filter, ["is_unfindable", Is_unfindable]}];

parse_argument({is_findable, Val}, Context) ->
    parse_argument({is_findable, z_convert:to_bool(Val)}, Context);

parse_argument({cat_exclude_defaults, Bool}, _Context) when is_boolean(Bool) ->
    case Bool of
        true ->
            [{cat_exclude, [meta, menu, admin_content_query]}];
        false ->
            []
    end;

parse_argument({cat_exclude_defaults, Val}, Context) ->
    parse_argument({cat_exclude_defaults, z_convert:to_bool(Val)}, Context);

parse_argument({cat_exclude_unfindable, Val}, Context) ->
    case z_convert:to_bool(Val) of
        true ->
            [{cat_exclude, get_unfindable_categories(Context)}];
        false ->
            []
    end;

% Filtering on undefined is supported from Zotonic 0.13.16
parse_argument({has_geo, true}, _Context) ->
    [{filter, ["pivot_location_lat", ne, undefined]},
     {filter, ["pivot_location_lng", ne, undefined]}];

parse_argument({has_geo, false}, _Context) ->
    [{filter, ["pivot_location_lat", eq, undefined]},
     {filter, ["pivot_location_lng", eq, undefined]}];

parse_argument({has_geo, Val}, Context) ->
    parse_argument({has_geo, z_convert:to_bool(Val)}, Context);

parse_argument({_, undefined}, _Context) ->
    [];

parse_argument({Key, <<"undefined">>}, Context) ->
    parse_argument({Key, undefined}, Context);

parse_argument(Arg, _Context) ->
    [Arg].

%% @doc Process custom arguments and add defaults
merge_ginger_args(Args, Context) ->

    % Always set these extra query arguments
    ExtraArgs = [
        {custompivot, ?GINGER_SEARCH_PIVOT}
    ],
    MergedArgs = lists:merge(ExtraArgs, Args),

    % Associate default arguments
    DefaultArgs = [
        {is_findable, true},
        {is_published, true},
        {cat_exclude_defaults, true},
        {cat_exclude_unfindable, true}
    ],
    MergedArgs1 = withdefault(DefaultArgs, MergedArgs),

    % Parse custom ginger_search arguments
    lists:flatmap(
        fun(Arg) ->
            parse_argument(Arg, Context)
        end,
        MergedArgs1
    ).
