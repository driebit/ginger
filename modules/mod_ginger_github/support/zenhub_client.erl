%% @doc ZenHub API client
-module(zenhub_client).

-include_lib("zotonic.hrl").

-export([
    request/2
]).

%% @doc Execute request to ZenHub API
-spec request(string(), #context{}) -> list().
request(Url, Context) ->
    ginger_http_client:get("https://api.zenhub.io/p1/" ++ Url, headers(Context)).

headers(Context) ->
    [
        {"X-Authentication-Token", z_convert:to_list(m_config:get_value(mod_ginger_github, zenhub_token, Context))},
        {"User-Agent", "Ginger"}
    ].
