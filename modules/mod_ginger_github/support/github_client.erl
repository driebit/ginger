%% @doc GitHub API client
-module(github_client).

-include_lib("zotonic.hrl").

-export([
    request/2
]).

%% @doc Execute request to GitHub API
-spec request(string(), #context{}) -> list().
request(Url, Context) ->
    case ginger_http_client:request("https://api.github.com/" ++ Url, headers(Context)) of
        undefined ->
            undefined;
        Response ->
            json_parser:parse(Response, fun parse_property/1)
    end.

headers(Context) ->
    [
        {"Authorization", "token " ++ z_convert:to_list(m_config:get_value(mod_ginger_github, oauth_token, Context))},
        {"User-Agent", "Ginger"},
        {"Accept", "application/vnd.github.v3+json"}
    ].

parse_property({<<"due_on">>, Date}) ->
    {<<"due_on">>, z_datetime:to_datetime(Date)};
parse_property({Key, Value}) ->
    {Key, Value}.
