-module(m_ginger_collection).

-export([
    m_find_value/3,

    default_index/1,
    collection_index/1,
    is_elastic2/1
]).

-include("zotonic.hrl").

m_find_value(default_index, #m{}, Context) ->
    default_index(Context);
m_find_value(collection_index, #m{}, Context) ->
    collection_index(Context);
m_find_value(query_preview_delegate, #m{}, Context) ->
    case is_elastic2(Context) of
        true -> elasticsearch2_admin;
        false -> controller_admin_elasticsearch_edit
    end.

%% @doc Check if we use mod_elasticsearch2 or mod_elasticsearch
is_elastic2(Context) ->
    case m_config:get_value(mod_elasticsearch2, index, Context) of
        undefined ->
            false;
        _Index ->
            true
    end.

default_index(Context) ->
    case is_elastic2(Context) of
        true ->
            elasticsearch2:index(Context);
        false ->
            elasticsearch:index(Context)
    end.

%% @doc Get Elasticsearch index name used for collections.
-spec collection_index(z:context()) -> binary().
collection_index(Context) ->
    case z_convert:to_binary(m_config:get_value(mod_ginger_collection, index, Context)) of
        <<>> ->
            Default = default_index(Context),
            <<Default/binary, "_collection">>;
        Index ->
            Index
    end.
