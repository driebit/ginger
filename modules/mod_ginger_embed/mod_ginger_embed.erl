%% @author Driebit <info@driebit.nl>
%% @copyright 2015

-module(mod_ginger_embed).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger Embed").
-mod_description("Ginger Embed").
-mod_prio(250).
-mod_depends([mod_content_groups, mod_acl_user_groups, mod_ginger_rdf]).

-mod_schema(1).

-export([
    manage_schema/2,
    observe_media_viewer/2,
    observe_rsc_update/3
]).

-include("zotonic.hrl").

manage_schema(_Version, Context) ->
    m_config:set_value(site, html_elt_extra, <<"embed,iframe,object,script,ginger-embed">>, Context),
    m_config:set_value(site, html_attr_extra, <<"data,allowfullscreen,flashvars,frameborder,scrolling,async,defer,data-rdf">>, Context),
    Datamodel = #datamodel{
        categories=[
            {ginger_embed, media, [
                {title, {trans, [
                    {nl, <<"Ginger embed">>},
                    {en, <<"Ginger embed">>}]}},
                {language, [en, nl]}
            ]}
        ]
    },
    z_datamodel:manage(?MODULE, Datamodel, Context).

%% @doc Render embed template in case of <ginger-embed> element
-spec observe_media_viewer(#media_viewer{}, #context{}) -> {ok, binary()} | undefined.
observe_media_viewer(#media_viewer{props = Props}, Context) ->
    case ginger_embed:is_ginger_embed(Props) of
        true ->
            {ok, z_template:render("embed/ginger-embed.tpl", Props, Context)};
        false ->
            undefined
    end.

%% @doc Place Ginger embeds in the ginger_embed category.
%%      mod_video_embed hard-codes the video category, so we need to change it
%%      here.
-spec observe_rsc_update(#rsc_update{}, tuple(), #context{}) -> tuple().
observe_rsc_update(#rsc_update{id = Id}, {IsChanged, Acc}, Context) ->
    case m_media:get(Id, Context) of
        undefined ->
            {IsChanged, Acc};
        Media ->
            case ginger_embed:is_ginger_embed(Media) of
                true ->
                    {true, [{category_id, m_rsc:rid(ginger_embed, Context)} | proplists:delete(category_id, Acc)]};
                false ->
                    {IsChanged, Acc}
            end
    end.