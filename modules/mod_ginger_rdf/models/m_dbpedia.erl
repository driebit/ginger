%% @doc Template model for DBPedia resources.
-module(m_dbpedia).

-include_lib("zotonic.hrl").
-include_lib("../include/rdf.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    get_resource/2,
    get_resource/3,
    is_dbpedia_uri/1,
    is_wikidata_uri/1
]).

-define(CACHE_TYPE, <<"m_dbpedia:uri:fetch">>).


%% @doc Usage: m.dbpedia["http://nl.dbpedia.org/resource/Nederland"]
-spec m_find_value(ginger_uri:uri() | atom(), #m{}, z:context()) -> m_rdf:rdf_resource().
m_find_value(<<"http://", Uri/binary>>, #m{}, Context) ->
    get_resource(Uri, Context);
m_find_value(<<"https://", Uri/binary>>, #m{}, Context) ->
    get_resource(Uri, Context);
m_find_value(Language, #m{value = undefined} = M, _Context) ->
    M#m{value = Language};
m_find_value(Uri, #m{value = Language}, Context) ->
    get_resource(Uri, Language, Context).

m_to_list(_, _Context) ->
    [].

m_value(#m{value = Uri}, Context) ->
    get_resource(Uri, Context, nl).

%% @doc Get a resource from DBPedia or WikiData.
-spec get_resource(binary(), z:context()) -> m_rdf:rdf_resource() | undefined.
get_resource(<<"http://", Url/binary>>, Context) ->
    get_resource(Url, Context);
get_resource(<<"https://", Url/binary>>, Context) ->
    get_resource(Url, Context);
get_resource(<<"wikidata.dbpedia.org/", _/binary>> = Uri, Context) ->
    get_resource(Uri, <<"wikidata">>, Context);
get_resource(<<"nl.dbpedia.org", _/binary>> = Uri, Context) ->
    get_resource(Uri, <<"nl">>, Context);
get_resource(<<"dbpedia.org", _/binary>> = Uri, Context) ->
    get_resource(Uri, <<>>, Context).

-spec get_resource(Uri::binary(), Language::binary(), z:context()) -> m_rdf:rdf_resource() | undefined.
get_resource(Uri, Language, Context) ->
            get_resource_cached(Uri, Language, Context).
    % z_depcache:memo(
    %     fun() ->
    %         get_resource_cached(Uri, Language, Context)
    %     end,
    %     {Uri, Language},
    %     Context
    % ).

get_resource_cached(Uri, Language, Context) ->
    case cache_lookup(Uri, Language, Context) of
        {error, enoent} ->
            get_resource_fetch(Uri, Language, undefined, Context);
        {ok, {stale, Data}} ->
            % Try to refresh the cached data
            get_resource_fetch(Uri, Language, Data, Context);
        {ok, {valid, Data}} ->
            Data
    end.

get_resource_fetch(Uri, Language, StaleData, Context) ->
    Key = cache_key(Uri, Language),
    case dbpedia:get_resource(<<"http://", Uri/binary>>, Language) of
        undefined ->
            % Store errornous or stale data for an hour
            Till = z_datetime:next_hour( calendar:universal_time() ),
            TkvData = {dbpedia, StaleData, Till},
            z_notifier:first(
                #tkvstore_put{ type = ?CACHE_TYPE, key = Key, value = TkvData},
                Context),
            StaleData;
        Data ->
            % Store valid lookups for a day
            Till = z_datetime:next_day( calendar:universal_time() ),
            TkvData = {dbpedia, Data, Till},
            z_notifier:first(
                #tkvstore_put{ type = ?CACHE_TYPE, key = Key, value = TkvData},
                Context),
            Data
    end.

cache_lookup(Uri, Language, Context) ->
    Key = cache_key(Uri, Language),
    case z_notifier:first(#tkvstore_get{ type = ?CACHE_TYPE, key = Key }, Context) of
        undefined ->
            {error, enoent};
        {dbpedia, Data, ValidTill} ->
            case ValidTill >= calendar:universal_time() of
                true ->
                    {ok, {valid, Data}};
                false ->
                    {ok, {stale, Data}}
            end
    end.

cache_key(Uri, Language) ->
    iolist_to_binary( z_utils:hex_encode( crypto:hash(sha, [ Uri, "::", Language ]) ) ).


%% @doc Does the URI belong to DBPedia?
-spec is_dbpedia_uri(binary()) -> boolean().
is_dbpedia_uri(Uri) ->
    case binary:match(Uri, <<"dbpedia.org">>) of
        nomatch ->
            false;
        _Found ->
            true
    end.

%% @doc Does the URI belong to Wikidata?
-spec is_wikidata_uri(binary()) -> boolean().
is_wikidata_uri(Uri) ->
    case binary:match(Uri, <<"wikidata.dbpedia.org">>) of
        nomatch ->
            false;
        _Found ->
            true
    end.
