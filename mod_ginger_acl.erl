-module(mod_ginger_acl).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger acl module").
-mod_description("Provides extra ACL rules").
-mod_prio(500).

-include_lib("zotonic.hrl").

-export([
    is_authorized/2,
    observe_admin_rscform/3,
    observe_acl_is_allowed/2
]).

is_authorized(ReqData, Context) ->
    z_acl:wm_is_authorized(use, z_context:get(acl_module, Context, mod_admin), admin_logon, ReqData, Context).
    
observe_admin_rscform(#admin_rscform{id=Id}, Post, _Context) ->
    case proplists:is_defined("owner_id", Post) of
        true ->
            OwnerId = z_convert:to_integer(proplists:get_value("owner_id", Post)),
            z_db:q("update rsc set creator_id = $1 where id = $2", [OwnerId, Id], _Context),
            z_depcache:flush(Id, _Context),
            Post;
        false -> Post
    end.

observe_acl_is_allowed(#acl_is_allowed{object=#acl_edge{subject_id = SubjectId}}, Context) ->
    case m_rsc:p_no_acl(SubjectId, editable_for, Context) of
		<<"2">> -> can_group_edit(SubjectId, Context);
		_ -> 
            {rsc_list, Authors} = m_rsc:s(SubjectId, author, Context),
            %?DEBUG(Authors),
            case is_list(Authors) of
                true -> can_author_edit(Authors, Context);
                _ -> undefined
            end
	end;
observe_acl_is_allowed(#acl_is_allowed{action=update, object=Id}, Context) ->
    %?DEBUG(m_rsc:p_no_acl(Id, editable_for, Context)),
    case m_rsc:p_no_acl(Id, editable_for, Context) of
		<<"2">> -> can_group_edit(Id, Context);
		_ -> 
            {rsc_list, Authors} = m_rsc:o(Id, author, Context),
            ?DEBUG(Authors),
            case is_list(Authors) of
                true -> can_author_edit(Authors, Context);
                _ -> undefined
            end
	end;
observe_acl_is_allowed(#acl_is_allowed{}, _Context) ->
    undefined.

%% @doc A user can edit content his/her group created
can_group_edit(Id, #context{user_id=UserId} = Context) when UserId /= undefined ->
    RscGroupId = m_rsc:p_no_acl(Id, creator_id, Context),
    {rsc_list, Ids} = m_rsc:s(UserId, acl_role_member, Context),
    case in_list(RscGroupId, Ids, Context) of
        true -> true;
        _ -> undefined
    end.

%% @doc A user can edit when he/she is 1 of the authors
can_author_edit(Authors, #context{user_id=UserId} = Context) when UserId /= undefined ->
    case in_list(UserId, Authors, Context) of
        true -> true;
        _ -> undefined
    end.

%% @doc check if id is in list
in_list(Id, Ids, _Context) ->
    case lists:any(
        fun(FoundId) ->
            Id =:= FoundId
        end,
        Ids
    ) of
        true -> true;
        _ -> undefined
    end.

