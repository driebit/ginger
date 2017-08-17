%% @doc A wrapper around the Erfgoedthesaurus API
-module(m_erfgoedthesaurus).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).

m_find_value(Url, #m{value = undefined} = M, _Context) ->
    M#m{value = Url};
m_find_value(Key, #m{} = M, Context) when is_atom(Key) ->
    m_find_value(z_convert:to_binary(Key), M, Context);
m_find_value(Key, #m{value = <<"http://data.cultureelerfgoed.nl", _/binary>> = Url}, _Context) ->
    case ginger_http_client:get(Url) of
        Data when is_map(Data) ->
            maps:get(Key, Data, undefined);
        _ ->
            %% E.g. 404 or non-JSON data
            undefined
    end;
m_find_value(_Key, #m{value = _UnsupportedUrl}, _Context) ->
    undefined.

m_to_list(_, _Context) ->
    [].

m_value(#m{}, _Context) ->
    undefined.
