%% Creative Commons licenses and URLs
-module(m_creative_commons).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    url_for/1
]).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

m_find_value(License, #m{value = undefined} = M, _Context) ->
    M#m{value = License};
m_find_value(url, #m{value = License}, _Context) ->
    url_for(License);
m_find_value(language_url, #m{value = License}, Context) ->
    iolist_to_binary([
        url_for(License),
        <<"/deed.">>,
        z_convert:to_binary(z_context:language(Context))
    ]).

m_to_list(_, _Context) ->
    [].

m_value(_Source, _Context) ->
    undefined.

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
