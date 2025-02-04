%% @doc HTTP URIs.
%% Note that these routines also accept "httpss:", as that is a mistake
%% that does occur in some datasets we are using and we can't fix at
%% the source of those datasets.

-module(ginger_uri).

-export([
    uri/1,
    https/1,
    http/1
]).

-type uri() :: binary().

-export_type([
    uri/0
]).

%% @doc Construct a URI, ensure that the URL has http or https protocol.
-spec uri(binary()) -> uri().
uri(<<"http://", _/binary>> = Uri) -> Uri;
uri(<<"https://", _/binary>> = Uri) -> Uri;
uri(<<"httpss://", Uri/binary>>) ->  <<"https://", Uri/binary>>;
uri(<<"//", _/binary>> = Uri) -> <<"https:", Uri/binary>>.

%% @doc Force a URI to be HTTPS.
-spec https(binary()) -> uri().
https(<<"//", _/binary>> = Uri) -> <<"https:", Uri/binary>>;
https(<<"http://", Uri/binary>>) -> <<"https://", Uri/binary>>;
https(<<"https://", _/binary>> = Uri) -> Uri;
https(<<"httpss://", Uri/binary>>) -> <<"https://", Uri/binary>>.

%% @doc Force a URI to be HTTP.
-spec http(binary()) -> uri().
http(<<"//", _/binary>> = Uri) -> <<"http:", Uri/binary>>;
http(<<"http://", _/binary>> = Uri) -> Uri;
http(<<"https://", Uri/binary>>) -> <<"http://", Uri/binary>>;
http(<<"httpss://", Uri/binary>>) -> <<"http://", Uri/binary>>.
