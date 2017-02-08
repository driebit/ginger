-module(mod_beeldenzoeker).
-author("Driebit <tech@driebit.nl>").

-mod_title("Beeldenzoeker").
-mod_description("Beeldenzoeker module om digitale collecties in te zien").
-mod_prio(200).
-mod_depends([mod_ginger_base]).
-mod_schema(2).

-include_lib("zotonic.hrl").

-export([
    manage_schema/2
]).

manage_schema(_Version, _Context) ->
  #datamodel{
    categories=[
    ],
    resources=[
    	{beeldenzoeker, text, [
          {title, {trans, [{nl, <<"Beeldenzoeker">>},
                           {en, <<"Media discovery">>}]}},
          {language, [en,nl]},
          {is_unfindable, true}
        ]}
    ],
    edges=[
    ],
    predicates=[
    ],
    data = [
        % {acl_rules, [
        %     % {rsc, [
        %     %     {acl_user_group_id, acl_user_group_members},
        %     %     {actions, [insert, update, link, delete]},
        %     %     {category_id, project},
        %     %     {is_owner, true}
        %     % ]}
        % ]}
    ]
  }.