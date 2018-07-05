%% @doc Force HTTPS URIs.
-module(filter_https).

-export([https/2]).

-include("zotonic.hrl").

-spec https(ginger_uri:uri() | undefined, z:context()) -> ginger_uri:uri().
https(undefined, _Context) ->
    undefined;
https(Uri, _Context) ->
    ginger_uri:https(Uri).
