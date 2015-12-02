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
    % This is a special use case that needs a better solution in Zotonic
    case z_context:get_q(filters, Context) of
        undefined ->
            Args1 = Args;
        Filters ->
            Args1 = lists:append([Args, [{filters, Filters}]])
    end,

    QueryArgs = merge_ginger_args(Args1, Context),
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
            case parse_argument(Arg) of
                F when is_function(F) ->
                    F(Context);
                L when is_list(L) ->
                    L
            end
        end,
        MergedArgs1
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
    Is_unfindable = not Bool,
    [{filter, ["is_unfindable", Is_unfindable]}];

parse_argument({is_findable, Val}) ->
    parse_argument({is_findable, z_convert:to_bool(Val)});

parse_argument({cat_exclude_defaults, Bool}) when is_boolean(Bool) ->
    case Bool of
        true ->
            [{cat_exclude, [meta, menu, admin_content_query]}];
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

% Filtering on undefined is supported from Zotonic 0.13.16
parse_argument({has_geo, true}) ->
    [{filter, ["pivot_location_lat", ne, undefined]},
     {filter, ["pivot_location_lng", ne, undefined]}];

parse_argument({has_geo, false}) ->
    [{filter, ["pivot_location_lat", eq, undefined]},
     {filter, ["pivot_location_lng", eq, undefined]}];

parse_argument({has_geo, Val}) ->
    parse_argument({has_geo, z_convert:to_bool(Val)});

parse_argument(Arg) ->
    [Arg].
