%% @doc Force HTTPS URIs.
-module(filter_https).

-export([https/2]).

-include("zotonic.hrl").

-spec https(ginger_uri:uri(), z:context()) -> ginger_uri:uri().
https(Uri, _Context) ->
    ginger_uri:https(Uri).
