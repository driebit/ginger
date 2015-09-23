-module(ginger_export_users).
-author("Driebit <tech@driebit.nl>").

-export([

]).

-include_lib("include/zotonic.hrl").
-include_lib("modules/mod_admin/include/admin_menu.hrl").


%% export(Query, Context) ->
%%     SearchResult = z_search:search({'query', Query}, {1, undefined}, Context),
%%     List = [ResultId || ResultId <- SearchResult#search_result.result],
%%     {<<>>, fun() -> do_body(List, Context) end }
%%
%%
%%     case z_notifier:first(#export_resource_encode{
%%         dispatch=Dispatch,
%%         content_type=ContentType,
%%         data=Item,
%%         state=undefined}, Context)
%%     of
%%         undefined -> <<>>;
%%         {ok, Enc} -> Enc
%%     end.
