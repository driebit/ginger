-module(ginger_search).

-export([search_query/2, withdefault/2]).

-include_lib("zotonic.hrl").

%% @doc Add property to proplist if not defined
withdefault({Key, _} = Prop, Proplist) ->
    case proplists:is_defined(Key, Proplist) of
        true ->
            Proplist;
        false ->
            lists:append(Proplist, [Prop])
    end.
    
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

parse_argument(Arg) ->
    [Arg].
    
%% @doc Supports all the usual query model arguments, adds default excludes.
search_query(#search_query{search={ginger_search, Args}}, Context) ->
    
    DefaultArgs = [
        % TODO: Fetch default cat_excludes from database
        {cat_exclude, [meta, menu, admin_content_query]},
        % TODO: Filter all resources within category if it is unfindable
        {custompivot,"ginger_search"},
        {filter,["is_unfindable",'=',"f"]}
    ],

    MergedArgs = lists:merge(DefaultArgs, Args),
    MergedArgs1 = withdefault({is_published, true}, MergedArgs),
    
    % Parse custom ginger_search arguments
    MergedArgs2 = lists:flatmap(fun parse_argument/1, MergedArgs1),
    
    search_query:search(MergedArgs2, Context).
