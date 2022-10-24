-module(filter_collection_object_url).

-export([
    collection_object_url/2
]).

collection_object_url(#{ <<"_id">> := DocId, <<"_type">> := <<"resource">> }, Context) ->
    url(<<"resource">>, DocId, Context);
collection_object_url(#{ <<"_id">> := DocId, <<"_source">> := #{ <<"es_type">> := <<"resource">> } }, Context) ->
    url(<<"resource">>, DocId, Context);
collection_object_url(#{ <<"_source">> := #{ <<"es_type">> := Type, <<"@id">> := Id } }, Context) ->
    % Elastic Search 7.x and later  (mod_elasticsearch2)
    url(Type, Id, Context);
collection_object_url(#{ <<"_source">> := #{ <<"es_type">> := Type, <<"priref">> := Id } }, Context) ->
    % Elastic Search 7.x and later  (mod_elasticsearch2)
    url(Type, Id, Context);
collection_object_url(#{ <<"_id">> := DocId, <<"_source">> := #{ <<"es_type">> := Type } }, Context) ->
    % Elastic Search 7.x and later  (mod_elasticsearch2)
    {Id, _} = mod_elasticsearch2:typed_id_split(DocId),
    url(Type, Id, Context);
collection_object_url(#{ <<"_type">> := Type, <<"_source">> := #{ <<"@id">> := Id } }, Context) ->
    % Elastic Search 5.x (mod_elasticsearch)
    url(Type, Id, Context);
collection_object_url(#{ <<"_type">> := Type, <<"_source">> := #{ <<"priref">> := Id } }, Context) ->
    % Elastic Search 5.x (mod_elasticsearch)
    url(Type, Id, Context);
collection_object_url(#{ <<"_id">> := DocId, <<"_type">> := Type }, Context) ->
    % Not all sites have elasticsearch2
    Id = case m_ginger_collection:is_elastic2(Context) of
        true ->
            {SplitId, _} = mod_elasticsearch2:typed_id_split(DocId),
            SplitId;
        false ->
            DocId
    end,
    url(Type, Id, Context);
collection_object_url(#{ <<"_id">> := DocId }, Context) ->
    % In future we might not have the _type added by mod_elasticsearch2
    {Id, Type} = mod_elasticsearch2:typed_id_split(DocId),
    url(Type, Id, Context);
collection_object_url(_Doc, _Context) ->
    undefined.


url(Type, Id, Context)
    when Type =:= <<"resource">>;
         Type =:= <<>>;
         Type =:= undefined ->
    case m_rsc:rid(Id, Context) of
        undefined ->
            undefined;
        RId ->
            m_rsc:page_url(RId, Context)
    end;
url(Type, Id, Context) ->
    z_dispatcher:url_for(
        collection_object,
        [ {database, Type}, {object_id, Id}],
        Context).
