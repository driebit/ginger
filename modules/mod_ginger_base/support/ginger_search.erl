-module(ginger_search).

-export([search_query/2, withdefault/2]).

-include_lib("zotonic.hrl").

%% Add property to proplist if not defined
withdefault({Key, _} = Prop, Proplist) ->
    case proplists:is_defined(Key, Proplist) of
        true ->
            Proplist;
        false ->
            lists:append(Proplist, [Prop])
    end.    

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
    
    search_query:search(MergedArgs1, Context).
