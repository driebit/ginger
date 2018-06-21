%% @doc HTTP URIs.
-module(ginger_uri).

-export([
    uri/1,
    https/1
]).

-type(uri() :: binary()).

-export_type([
    uri/0
]).

%% @doc Construct a URI.
-spec uri(binary()) -> uri().
uri(<<"http://", _/binary>> = Uri) ->
    Uri;
uri(<<"https://", _/binary>> = Uri) ->
    Uri.

%% @doc Force a URI to be HTTPS.
-spec https(uri()) -> uri().
https(<<"http://", Uri/binary>>) ->
    <<"https://", Uri/binary>>;
https(<<"https://", _/binary>> = Uri) ->
    Uri.
