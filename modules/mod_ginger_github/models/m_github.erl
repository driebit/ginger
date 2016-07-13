-module(m_github).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).

m_find_value(Url, #m{value = undefined}, Context) ->
    github_client:request(Url, Context).

m_to_list(_, _Context) ->
    [].

m_value(_Source, _Context) ->
    undefined.
