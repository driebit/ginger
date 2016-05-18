%% @author Driebit <tech@driebit.nl>
%% @copyright 2016

-module(mod_ginger_remark).
-author("Driebit <tech@driebit.nl>").

-mod_title("Ginger remark").
-mod_description("Enables simple adding of resources.").

-include_lib("zotonic.hrl").

-mod_prio(500).
-mod_schema(3).

-export([manage_schema/2]).

manage_schema(_Version, Context) ->
  m_config:set_value(i18n, language, nl, Context),
  #datamodel{
    categories=[
        {remark, text, [
            {title, {trans, [{nl, <<"Opmerking">>},
                             {en, <<"Remark">>}]}},
            {language, [en,nl]}
        ]}
    ],
    predicates=[
    ],
    resources=[
        {cg_user_generated, content_group, [
          {title, <<"User generated">>}
        ]}
    ],
    media=[
    ],
    edges=[
    ],
    data = [
        {acl_rules, [
            {rsc, [
                {acl_user_group_id, acl_user_group_anonymous},
                {actions, [insert]},
                {category_id, remark},
                {content_group_id, m_rsc:rid(cg_user_generated, Context)}
            ]},
            {rsc, [
                {acl_user_group_id, acl_user_group_anonymous},
                {actions, [insert]},
                {category_id, media},
                {content_group_id, m_rsc:rid(cg_user_generated, Context)}
            ]},
            {rsc, [
                {acl_user_group_id, acl_user_group_members},
                {actions, [update, link, delete]},
                {category_id, remark},
                {content_group_id, m_rsc:rid(cg_user_generated, Context)},
                {is_owner, true}
            ]}
        ]}
    ]}.
