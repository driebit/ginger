-module(m_collection_object).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,

    get/2,
    store/3,

    get/3,
    store/4
]).

m_find_value(uri, #m{value = undefined}, Context) ->
    z_dispatcher:url_for(
        collection_object,
        [
            {use_absolute_url, true},
            {database, z_context:get_q(<<"database">>, Context)},
            {object_id, z_context:get_q(<<"object_id">>, Context)}
        ],
        Context
    );
m_find_value(Type, #m{value = undefined} = M, _Context) ->
    M#m{value = Type};
m_find_value(Property, #m{value = #{<<"_index">> := _Index} = Object}, _Context) ->
    maps:get(z_convert:to_binary(Property), Object);
m_find_value(ObjectId, #m{value = Type}, Context) ->
    get(Type, ObjectId, Context).

m_to_list(_, _Context) ->
    [].

m_value(#m{ value = ObjectId }, Context) when is_binary(ObjectId) ->
    % ES 7+ object lookup
    get(ObjectId, Context);
m_value(#m{ value = Object }, _Context) ->
    Object.

%% @doc For ES 7.x+
get(Id, Context) ->
    Index = m_ginger_collection:collection_index(Context),
    case elasticsearch2:get_doc(Index, Id, Context) of
        {ok, Doc} ->
            Doc;
        {error, _} ->
            undefined
    end.

store(Id, Document, Context) ->
    Index = m_ginger_collection:collection_index(Context),
    elasticsearch2:put_doc(Index, Id, Document, Context).


%% @doc For ES 5.x with Types
get(Type, Id, Context) ->
    Index = m_ginger_collection:collection_index(Context),
    case m_ginger_collection:is_elastic2(Context) of
        true ->
            DocId = mod_elasticsearch2:typed_id(Id, Type),
            case elasticsearch2:get_doc(Index, DocId, Context) of
                {ok, Doc} ->
                    Doc;
                {error, enoent} ->
                    lager:info("m_collection_object: document not found '~s' index '~s'",
                               [ DocId, Index ]),
                    undefined;
                {error, _} ->
                    undefined
            end;
        false ->
            case erlastic_search:get_doc(
                Index,
                z_convert:to_binary(Type),
                z_convert:to_binary(Id)
            ) of
                {ok, Object} when is_map(Object) ->
                    Object;
                {error, _} ->
                    undefined
            end
    end.

store(Type, Id, Document, Context) ->
    Index = m_ginger_collection:collection_index(Context),
    case m_ginger_collection:is_elastic2(Context) of
        true ->
            Document1 = Document#{
                <<"es_type">> => Type
            },
            DocId = mod_elasticsearch2:typed_id(Id, Type),
            elasticsearch2:put_doc(Index, DocId, Document1, Context);
        false ->
            elasticsearch:put_doc(Index, Type, Id, Document, Context)
    end.
