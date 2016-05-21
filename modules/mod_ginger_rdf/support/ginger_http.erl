%% @doc HTTP utility functions
%% @author David de Boer <david@driebit.nl>
-module(ginger_http).

%% API
-export([
    is_http_uri/1
]).

%% @doc Is String a valid URI?
-spec is_http_uri(string()) -> boolean().
is_http_uri(String) ->
    {Scheme, _, _, _, _} = mochiweb_util:urlsplit(z_convert:to_list(String)),
    case Scheme of
        "http" -> true;
        "https" -> true;
        _ -> false
    end.
