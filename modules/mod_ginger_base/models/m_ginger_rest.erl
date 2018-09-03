%% @doc Model for REST representations of Zotonic resources.
-module(m_ginger_rest).

-export([
    rsc/2,
    with_edges/2,
    with_edges/3,
    translations/2
]).

-type language() :: atom().
-type translations() :: [{language(), binary()}].
-type resource_properties() :: map().

-include_lib("zotonic.hrl").
-include_lib("stdlib/include/qlc.hrl").

%% @doc Get REST resource properties.
-spec rsc(m_rsc:resource(), z:context()) -> resource_properties().
rsc(Id, Context) ->
    Rsc = #{
        <<"id">> => Id,
        <<"title">> => translations(Id, title, Context),
        <<"body">> => translations(Id, body, Context),
        <<"summary">> => translations(Id, summary, Context),
        <<"path">> => m_rsc:page_url(Id, Context),
        <<"publication_date">> => m_rsc:p(Id, publication_start, null, Context),
        <<"categories">> => proplists:get_value(is_a, m_rsc:p(Id, category, Context)),
        <<"properties">> => custom_props(Id, Context)
    },
    with_media(Rsc, Context).

%% @doc Add all edges to resource.
-spec with_edges(map(), z:context()) -> map().
with_edges(Rsc = #{<<"id">> := Id}, Context) ->
    Edges = lists:flatmap(
        fun({Key, Edges}) ->
            [
                #{
                    <<"predicate_name">> => Key,
                    <<"resource">> => rsc(proplists:get_value(object_id, Edge), Context)
                } || Edge <- lists:reverse(Edges)
            ]
        end,
        m_edge:get_edges(Id, Context)
    ),
    Rsc#{<<"edges">> => Edges}.

%% @doc Add edges of specific predicates to resource.
-spec with_edges(map(), [atom()], z:context()) -> map().
with_edges(Rsc = #{<<"id">> := Id}, Predicates, Context) ->
    Edges = lists:flatmap(
        fun(Predicate) ->
            #rsc_list{list = Objects} = m_rsc:o(Id, Predicate, Context),
            [
                #{
                    <<"predicate_name">> => Predicate,
                    <<"resources">> => [rsc(O, Context) || O <- Objects]
                }
            ]
        end,
        Predicates
    ),
    Rsc#{<<"edges">> => Edges}.

%% @doc Get resource translations.
-spec translations(atom() | {trans, proplists:proplist()}, z:context()) -> translations().
translations({trans, Translations}, Context) ->
    [{Key, z_html:unescape(filter_show_media:show_media(Value, Context))} || {Key, Value} <- Translations];
translations(Value, Context) ->
    [{z_trans:default_language(Context), Value}].

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
            maps:fold(
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
            )
    end.

-spec with_media(map(), z:context()) -> map().
with_media(Rsc, Context) ->
    with_media(Rsc, mediaclasses(Context), Context).

-spec with_media(map(), [atom()], z:context()) -> map().
with_media(Rsc = #{<<"id">> := Id}, Mediaclasses, Context) ->
    case m_media:get(Id, Context) of
        undefined ->
            Rsc;
        _ ->
            Media = fun(Class, Acc) ->
                Opts = [{use_absolute_url, true}, {mediaclass, Class}],
                case z_media_tag:url(Id, Opts, Context) of
                    {ok, Url} ->
                        [#{mediaclass => Class, url => Url} | Acc];
                    _ ->
                        Acc
                end
                    end,
            Rsc#{<<"media">> => lists:foldr(Media, [], Mediaclasses)}
    end.

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
