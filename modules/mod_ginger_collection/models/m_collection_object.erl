-module(m_collection_object).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).

m_find_value(Thing, #m{value = undefined} = M, _Context) ->
    M#m{value = Thing};
m_find_value(uri, #m{value = _Object}, Context) ->
    z_dispatcher:url_for(
        adlib_object,
        [
            {use_absolute_url, true},
            {database, z_context:get_q(<<"database">>, Context)},
            {object_id, z_context:get_q(<<"object_id">>, Context)}
        ],
        Context
    ).

m_to_list(_, _Context) ->
    [].

m_value(_Source, _Context) ->
    undefined.


