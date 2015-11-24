-module(ginger_search).

-export([search_query/2, merge_ginger_args/1]).

-include_lib("zotonic.hrl").

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
    
parse_argument({is_findable, undefined}) ->
    [];
    
parse_argument({is_findable, <<"undefined">>}) ->
    parse_argument({is_findable, undefined});    

parse_argument({is_findable, Bool}) when is_boolean(Bool) ->
    % TODO: Filter all resources within category if it is unfindable
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

parse_argument({cat_exclude_defaults, undefined}) ->
    [];

parse_argument({cat_exclude_defaults, Val}) ->
    parse_argument({cat_exclude_defaults, z_convert:to_bool(Val)});

parse_argument(Arg) ->
    [Arg].
    
%% @doc Process custom arguments and add defaults
merge_ginger_args(Args) ->
    
    % Always set these extra query arguments
    ExtraArgs = [
        {custompivot, "ginger_search"}
    ],
    MergedArgs = lists:merge(ExtraArgs, Args),

    % Associate default arguments
    DefaultArgs = [
        {is_findable, true},
        {is_published, true},
        {cat_exclude_defaults, true}
    ],
    MergedArgs1 = withdefault(DefaultArgs, MergedArgs),

    % Parse custom ginger_search arguments
    lists:flatmap(fun parse_argument/1, MergedArgs1).
    
%% @doc Supports all the usual query model arguments, adds default excludes.
search_query(#search_query{search={ginger_search, Args}}, Context) ->
    QueryArgs = merge_ginger_args(Args),
    search_query:search(QueryArgs, Context).
