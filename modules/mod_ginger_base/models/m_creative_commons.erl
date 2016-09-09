%% Creative Commons licenses and URLs
-module(m_creative_commons).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    url_for/1,
    language_url_for/2
]).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

m_find_value(License, #m{value = undefined} = M, _Context) ->
    M#m{value = License};
m_find_value(url, #m{value = License}, _Context) ->
    url_for(License);
m_find_value(language_url, #m{value = License}, Context) ->
    language_url_for(License, Context).

m_to_list(_, _Context) ->
    [].

m_value(_Source, _Context) ->
    undefined.

%% @doc Get URL to license at the Creative Commons website
-spec url_for(binary() | string()) -> binary() | undefined.
url_for(License) when is_list(License) ->
    url_for(z_convert:to_binary(License));
url_for(<<"BY">>) ->
    <<"http://creativecommons.org/licenses/by/4.0">>;
url_for(<<"BY,SA">>) ->
    <<"http://creativecommons.org/licenses/by-sa/4.0">>;
url_for(<<"BY,ND">>) ->
    <<"http://creativecommons.org/licenses/by-nd/4.0">>;
url_for(<<"BY,NC">>) ->
    <<"http://creativecommons.org/licenses/by-nc/4.0">>;
url_for(<<"BY,NC,SA">>) ->
    <<"http://creativecommons.org/licenses/by-nc-sa/4.0">>;
url_for(<<"BY,NC,ND">>) ->
    <<"http://creativecommons.org/licenses/by-nc-nd/4.0">>;
url_for(<<"CC0">>) ->
    <<"http://creativecommons.org/publicdomain/zero/1.0">>;
url_for(<<"PD">>) ->
    <<"http://creativecommons.org/publicdomain/mark/1.0">>;
url_for(_) ->
    undefined.

%% @doc Get URL to translated license at the Creative Commons website
-spec language_url_for(binary(), #context{}) -> binary() | undefined.
language_url_for(License, Context) ->
    with_language(url_for(License), Context).

-spec with_language(binary() | undefined, #context{}) -> binary() | undefined.
with_language(undefined, _Context) ->
    undefined;
with_language(Url, Context) ->
    iolist_to_binary([
        Url,
        <<"/deed.">>,
        z_convert:to_binary(z_context:language(Context))
    ]).
