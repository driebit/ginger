-module(m_collection_object).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    get/3
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
m_find_value(ObjectId, #m{value = Type} = M, Context) ->
    M#m{value = get(Type, ObjectId, Context)}.

m_to_list(_, _Context) ->
    [].

m_value(#m{value = Object}, _Context) ->
    Object.

get(Type, Id, Context) ->
    case erlastic_search:get_doc(
        mod_ginger_adlib_elasticsearch:index(Context),
        z_convert:to_binary(Type),
        z_convert:to_binary(Id)
    ) of
        {ok, Object} when is_list(Object) ->
            %% BC with jsx 2.0
            maps:from_list(Object);
        {ok, Object} when is_map(Object) ->
            Object;
        {error, _} ->
            undefined
    end.
