%% @doc Force HTTPS URIs.
-module(filter_https).

-export([https/2]).

-include("zotonic.hrl").

-spec https(binary(), z:context()) -> binary().
https(<<"http://", Uri/binary>>, _Context) ->
    <<"https://", Uri/binary>>;
https(Uri, _Context) ->
    Uri.
