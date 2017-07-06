%% Creative Commons licenses and URLs
-module(m_creative_commons).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    url_for/1,
    language_url_for/2,
    label/1
]).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

m_find_value(License, #m{value = undefined} = M, _Context) ->
    M#m{value = License};
m_find_value(url, #m{value = License}, _Context) ->
    url_for(License);
m_find_value(language_url, #m{value = License}, Context) ->
    language_url_for(License, Context);
m_find_value(label, #m{value = Uri}, _Context) ->
    label(Uri).

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
url_for(<<"BY-SA">>) ->
    <<"http://creativecommons.org/licenses/by-sa/4.0">>;
url_for(<<"BY-ND">>) ->
    <<"http://creativecommons.org/licenses/by-nd/4.0">>;
url_for(<<"BY-NC">>) ->
    <<"http://creativecommons.org/licenses/by-nc/4.0">>;
url_for(<<"BY-NC-SA">>) ->
    <<"http://creativecommons.org/licenses/by-nc-sa/4.0">>;
url_for(<<"BY-NC-ND">>) ->
    <<"http://creativecommons.org/licenses/by-nc-nd/4.0">>;
url_for(<<"CC0">>) ->
    <<"http://creativecommons.org/publicdomain/zero/1.0">>;
url_for(<<"PD">>) ->
    <<"http://creativecommons.org/publicdomain/mark/1.0">>;
url_for(<<"CC ", License/binary>>) ->
    versioned_license(binary:split(License, <<" ">>));
url_for(<<"http://creativecommons.org/", _/binary>> = Url) ->
    url_for(label(Url));
url_for(Other) ->
    %% Values are stored as BY,SA in Ginger
    case binary:replace(Other, <<",">>, <<"-">>) of
        Replace when Replace =/= Other ->
            url_for(Replace);
        _ ->
            undefined
    end.

label(<<"https://", Url/binary>>) ->
    label(<<"http://", Url/binary>>);
label(<<"http://creativecommons.org/licenses/", Label/binary>>) ->
    label(Label);
label(<<"by/", _Version/binary>>) ->
    <<"BY">>;
label(<<"by-sa/", _Version/binary>>) ->
    <<"BY-SA">>;
label(<<"by-nd/", _Version/binary>>) ->
    <<"BY-ND">>;
label(<<"by-nc/", _Version/binary>>) ->
    <<"BY-NC">>;
label(<<"by-nc-sa/", _Version/binary>>) ->
    <<"BY-NC-SA">>;
label(<<"by-nc-nd/", _Version/binary>>) ->
    <<"BY-NC-ND">>;
label(<<"http://creativecommons.org/publicdomain/zero/", _Version/binary>>) ->
    <<"CC0">>;
label(<<"http://creativecommons.org/publicdomain/mark/", _Version/binary>>) ->
    <<"PD">>.

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

versioned_license([<<"BY", _/binary>> = Type, Version]) ->
    <<"http://creativecommons.org/licenses/", Type/binary, "/", Version/binary>>;
versioned_license([<<"CC0">>, Version]) ->
    <<"http://creativecommons.org/publicdomain/zero/", Version/binary>>;
versioned_license([<<"PD">>, Version]) ->
    <<"http://creativecommons.org/publicdomain/mark/", Version/binary>>.
