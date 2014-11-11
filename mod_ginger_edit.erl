-module(mod_ginger_edit).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger frontend edit module").
-mod_description("Provides Ginger frontend editing and adding dialogs").
-mod_prio(500).

-include_lib("zotonic.hrl").

-export([is_authorized/2,
    event/2,
    observe_admin_rscform/3,
    observe_acl_is_allowed/2
    ]).

is_authorized(ReqData, Context) ->
    z_acl:wm_is_authorized(use, z_context:get(acl_module, Context, mod_admin), admin_logon, ReqData, Context).


%% overrule van mod_admin om de connect lijst naar andere template te laten renderen    
event(#postback_notify{message="feedback", trigger="dialog-connect-find", target=TargetId}, Context) ->
                                                % Find pages matching the search criteria.
    SubjectId = z_convert:to_integer(z_context:get_q(subject_id, Context)),
    Category = z_context:get_q(find_category, Context),
    Text=z_context:get_q(find_text, Context),
    Cats = case Category of
                "p:"++Predicate -> m_predicate:object_category(Predicate, Context);
                "" -> [];
                CatId -> [{z_convert:to_integer(CatId)}]
           end,
    Vars = [
        {subject_id, SubjectId},
        {cat, Cats},
        {text, Text}
    ],
    z_render:wire([
        {remove_class, [{target, TargetId}, {class, "loading"}]},
        {update, [{target, TargetId}, {template, "_action_dialog_connect_tab_find_results.tpl"} | Vars]}
    ], Context).
    
observe_admin_rscform(#admin_rscform{id=Id}, Post, _Context) ->
    case proplists:is_defined("creator_id", Post) of
        true ->
            CreatorId = z_convert:to_integer(proplists:get_value("creator_id", Post)),
            z_db:q("update rsc set creator_id = $1 where id = $2", [CreatorId, Id], _Context),
            z_depcache:flush(Id, _Context),
            Post;
        false -> Post
    end.

observe_acl_is_allowed(#acl_is_allowed{action=update, object=Id}, Context) ->
    case m_rsc:p_no_acl(Id, editable_for, Context) of
		<<"2">> -> can_group_edit(Id, Context);
		_ -> undefined
	end;
observe_acl_is_allowed(#acl_is_allowed{}, _Context) ->
    undefined.

%% @doc A user can edit content his/her group created
can_group_edit(Id, #context{user_id=UserId, acl=ACL} = Context) when UserId /= undefined ->
    RscGroupId = m_rsc:p_no_acl(Id, creator_id, Context),
    {rsc_list, Ids} = m_rsc:s(UserId, acl_role_member, Context),
    case lists:any(
        fun(UserGroupId) ->
            RscGroupId =:= UserGroupId
        end,
        Ids
    ) of
        true -> true;
        _ -> undefined
    end.

