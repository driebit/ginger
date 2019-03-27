%% @doc Model for REST representations of Zotonic resources.
-module(m_ginger_rest).

-export([
    rsc/2,
    with_edges/3,
    with_edges/4,
    translations/2
]).

-type language() :: atom().
-type translations() :: [{language(), binary()}].
-type resource_properties() :: map().

-include_lib("zotonic.hrl").
-include_lib("stdlib/include/qlc.hrl").

%% @doc Get REST resource properties.
-spec rsc(m_rsc:resource(), z:context()) -> resource_properties() | undefined.
rsc(Id, Context) when is_integer(Id) ->
    Rsc = #{ <<"id">> => Id
           , <<"title">> => translations(Id, title, Context)
           , <<"subtitle">> => translations(Id, subtitle, Context)
           , <<"body">> => translations(Id, body, Context)
           , <<"summary">> => translations(Id, summary, Context)
           , <<"path">> => m_rsc:p(Id, page_path, m_rsc:page_url(Id, Context), Context)
           , <<"publication_date">> => m_rsc:p(Id, publication_start, null, Context)
           , <<"categories">> => proplists:get_value(is_a, m_rsc:p(Id, category, Context))
           , <<"properties">> => custom_props(Id, Context)
           , <<"blocks">> => blocks(Id, Context)
           },
    with_media(Rsc, Context);
rsc(UniqueName, Context) ->
    case m_rsc:name_to_id(UniqueName, Context) of
        {ok, Id} ->
            rsc(Id, Context);
        _ ->
            undefined
    end.

%% @doc Add all edges to resource.
-spec with_edges(map(), integer(), z:context()) -> map().
with_edges(Rsc = #{<<"id">> := Id}, Depth, Context) ->
    Edges = lists:flatmap(
              fun({Predicate, PredicateEdges}) ->
                      [
                       #{
                         <<"predicate_name">> => Predicate,
                         <<"resource">> =>
                             case Depth of
                                 1 ->
                                     rsc(proplists:get_value(object_id, Edge), Context);
                                 N ->
                                     Rsc2 = rsc(proplists:get_value(object_id, Edge), Context),
                                     with_edges(Rsc2, (N - 1), Context)
                             end
                        }
                       || Edge <- lists:reverse(PredicateEdges)
                      ]
              end,
              m_edge:get_edges(Id, Context)
             ),
    Rsc#{<<"edges">> => Edges}.


%% @doc Add edges of specific predicates to resource.
-spec with_edges(map(), [atom()], integer(), z:context()) -> map().
with_edges(Rsc = #{<<"id">> := Id}, Predicates, Depth, Context) ->
    Edges = lists:flatmap(
        fun(Predicate) ->
            #rsc_list{list = Objects} = m_rsc:o(Id, Predicate, Context),
            [
                #{
                    <<"predicate_name">> => Predicate,
                    <<"resource">> =>
                      case Depth of
                          1 ->
                              rsc(Object, Context);
                          N ->
                              with_edges(rsc(Object, Context), Predicates, (N - 1), Context)
                      end
                } || Object <- Objects
            ]
        end,
        Predicates
    ),
    case Depth of
        1 ->
            Rsc#{<<"edges">> => Edges};
        N ->
            Edges2 = lists:map(fun(Edge) -> with_edges(Edge, Predicates, (N - 1), Context) end, Edges),
            Rsc#{<<"edges">> => Edges2}
    end.

%% @doc Get resource translations.
-spec translations(atom() | {trans, proplists:proplist()}, z:context()) -> translations().
translations({trans, Translations}, Context) ->
    [{Key, z_html:unescape(filter_show_media:show_media(Value, Context))} || {Key, Value} <- Translations];
translations(undefined, Context) ->
    [{z_trans:default_language(Context), <<"">>}];
translations(Value, Context) ->
    [{z_trans:default_language(Context), z_html:unescape(filter_show_media:show_media(Value, Context))}].

%% @doc Get resource property translations.
-spec translations(m_rsc:resource(), atom(), z:context()) -> translations().
translations(Id, Property, Context) ->
    translations(m_rsc:p(Id, Property, <<>>, Context), Context).

%% @doc Get resource custom properties as defined in the site's config.
-spec custom_props(m_rsc:resource(), z:context()) -> resource_properties() | null.
custom_props(Id, Context) ->
    case m_site:get(types, Context) of
        undefined ->
            null;
        CustomProps ->
            case maps:fold(
                fun(PropName, TypeModule, Acc) ->
                    Value = m_rsc:p(Id, PropName, Context),
                    case z_utils:is_empty(Value) of
                        true ->
                            Acc;
                        false ->
                            Acc#{PropName => TypeModule:encode(Value)}
                    end
                end,
                #{},
                CustomProps
            ) of
                Map when map_size(Map) =:= 0 ->
                    null;
                CustomPropsValues ->
                    CustomPropsValues
            end
    end.

-spec with_media(map(), z:context()) -> map().
with_media(Rsc, Context) ->
    with_media(Rsc, mediaclasses(Context), Context).

-spec with_media(map(), [atom()], z:context()) -> map().
with_media(Rsc = #{<<"id">> := Id}, Mediaclasses, Context) ->
    case m_media:get(Id, Context) of
        undefined ->
            Rsc;
        Medium ->
            case proplists:get_value(mime, Medium) of
                <<"image", _Rest/binary>> ->
                    Rsc#{<<"media">> => image_urls(Id, Mediaclasses, Context)};
                <<"text/html-oembed">> ->
                    case proplists:get_value(oembed, Medium) of
                        undefined ->
                            Rsc;
                        EmbeddedInfo ->
                            Url = proplists:get_value(html, EmbeddedInfo),
                            Height = proplists:get_value(height, EmbeddedInfo, null),
                            Width = proplists:get_value(width, EmbeddedInfo, null),
                            Rsc#{<<"media">> => #{url => Url, width => Width, height => Height}}
                    end
            end
    end.

%% @doc Create a list of maps containing the given mediaclasses and corresponding URLs
-spec image_urls(m_rsc:resource(), [binary()], z:context()) -> [map()].
image_urls(RscId, Mediaclasses, Context) ->
    lists:foldr(
      fun(Class, Acc) ->
              Opts = [{use_absolute_url, true}, {mediaclass, Class}],
              case z_media_tag:url(RscId, Opts, Context) of
                  {ok, Url} ->
                      [#{mediaclass => Class, url => Url} | Acc];
                  _ ->
                      Acc
              end
      end, [], Mediaclasses).

%% @doc Get all mediaclasses for the site.
-spec mediaclasses(z:context()) -> [atom()].
mediaclasses(Context) ->
    Site = z_context:site(Context),
    Q = qlc:q([ R#mediaclass_index.key#mediaclass_index_key.mediaclass
                || R <- ets:table(?MEDIACLASS_INDEX),
                   R#mediaclass_index.key#mediaclass_index_key.site == Site
              ]
             ),
    lists:filter(
      fun
          (<<"admin-", _/bytes>>) ->
              false;
          (_) ->
              true
      end,
      lists:usort(qlc:eval(Q))
     ).

%% @doc Get resource blocks.
-spec blocks(m_rsc:resouce(), z:context()) -> [map()].
blocks(Id, Context) ->
    case m_rsc:p(Id, blocks, [], Context) of
        <<>> ->
            [];
        Blocks ->
            [block(Block, Context) || Block <- Blocks]
    end.

%% @doc Maybe translate each block property.
-spec block(proplists:proplist(), z:context()) -> map.
block(Block, Context) ->
    #{
        <<"type">> => proplists:get_value(type, Block),
        <<"name">> => proplists:get_value(name, Block),
        <<"title">> => translations(proplists:get_value(title, Block), Context),
        <<"subtitle">> => translations(proplists:get_value(subtitle, Block), Context),
        <<"body">> => translations(proplists:get_value(body, Block), Context),
        <<"rsc_id">> => proplists:get_value(rsc_id, Block, null),
        <<"properties">> => custom_block_props(Block, Context)
    }.

%% @doc Get block custom properties as defined in the site's config.
custom_block_props(Block, Context) ->
    case m_site:get(block_types, Context) of
        undefined ->
            null;
        CustomProps ->
            case maps:fold(
                fun(PropName, TypeModule, Acc) ->
                    case proplists:get_value(PropName, Block, undefined) of
                        undefined ->
                            Acc;
                        Value ->
                            Acc#{PropName => TypeModule:encode(Value)}
                    end
                end,
                #{},
                CustomProps
            ) of
                Map when map_size(Map) =:= 0 ->
                    null;
                CustomPropsValues ->
                    CustomPropsValues
            end
    end.
