%% @doc A filter to get the full collection query offset from query parameters.
%%      The current item on the page is needed and the page number from the
%%      search result is needed to get the offset.
-module(filter_collection_query_offset).

-export([
    collection_query_offset/4
]).

-include_lib("zotonic.hrl").

collection_query_offset(Current, Pagelen, undefined, _Context) ->
    get_offset(Current, Pagelen, 0);
collection_query_offset(Current, Pagelen, Page, _Context) ->
    get_offset(Current, Pagelen, Page-1).

get_offset(Current, Pagelen, Page) ->
    PagesOffset = Pagelen*Page,
    PagesOffset+Current.
