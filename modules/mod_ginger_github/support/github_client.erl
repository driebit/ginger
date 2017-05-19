%% @doc GitHub API client
-module(github_client).

-include_lib("zotonic.hrl").

-export([
    request/2
]).

%% @doc Execute request to GitHub API
-spec request(string(), z:context()) -> list().
request(Url, Context) ->
    ginger_http_client:get("https://api.github.com/" ++ Url, headers(Context)).

headers(Context) ->
    [
        {"Authorization", "token " ++ z_convert:to_list(m_config:get_value(mod_ginger_github, oauth_token, Context))},
        {"User-Agent", "Ginger"},
        {"Accept", "application/vnd.github.v3+json"}
    ].
