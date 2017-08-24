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
m_find_value(Key, #m{value = <<"http://data.cultureelerfgoed.nl", _/binary>> = Url}, Context) ->
    %% data.cultureelerfgoed.nl is no more; Erfgoedthesaurus is managed by PoolParty
    Concept = m_poolparty:concept(Url, Context),
    maps:get(Key, Concept, undefined);
m_find_value(_Key, #m{value = _UnsupportedUrl}, _Context) ->
    undefined.

m_to_list(_, _Context) ->
    [].

m_value(#m{}, _Context) ->
    undefined.
