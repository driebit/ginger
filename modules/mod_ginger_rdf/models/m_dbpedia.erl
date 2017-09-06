%% @doc Template model for DBPedia resources.
-module(m_dbpedia).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    get_resource/3,
    is_dbpedia_uri/1
]).

m_find_value(Language, #m{value = undefined} = M, _Context) ->
    M#m{value = Language};
m_find_value(Uri, #m{value = Language}, Context) ->
    get_resource(Uri, Language, Context).

m_to_list(_, _Context) ->
    [].

m_value(#m{value = Uri}, Context) ->
    get_resource(Uri, Context, nl).

get_resource(Uri, Language, Context) ->
    z_depcache:memo(
        fun() ->
            dbpedia:describe(Uri, Language)
        end,
        {Uri, Language},
        Context
    ).

%% @doc Does the URI belong to DBPedia?
-spec is_dbpedia_uri(binary()) -> boolean().
is_dbpedia_uri(Uri) ->
    case binary:match(Uri, <<"dbpedia.org">>) of
        nomatch ->
            false;
        _Found ->
            true
    end.
