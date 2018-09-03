-module(m_ginger_rsc).

-export([
    abstract/2,
    translations/2
]).

-type language() :: atom().
-type translations() :: [{language(), binary()}].
-type resource_properties() :: map().

-include_lib("zotonic.hrl").

%% @doc Get short representation of a resource.
-spec abstract(m_rsc:resource(), z:context()) -> resource_properties().
abstract(Id, Context) ->
    #{
        id => Id,
        title => translations(Id, title, Context),
        body => translations(Id, body, Context),
        summary => translations(Id, summary, Context),
        path => m_rsc:page_url(Id, Context),
        publication_date => m_rsc:p(Id, publication_start, null, Context),
        categories => proplists:get_value(is_a, m_rsc:p(Id, category, Context)),
        properties => custom_props(Id, Context)
    }.

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
