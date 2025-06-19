%% @doc User Group util functions
%% Functions to move the new moderator user group between editor user group and manager user group

-module(ginger_user_group).

-export([
    move_moderator_user_group/1,
    move_manager_user_group/1
]).

move_moderator_user_group(Context0) ->
    Context = z_acl:sudo(Context0),
    Moderators = m_rsc:name_to_id_check(acl_user_group_moderators, Context),
    Editors = m_rsc:name_to_id_check(acl_user_group_editors, Context),
    move_user_group(Moderators, Editors, Context).

move_manager_user_group(Context0) ->
    Context = z_acl:sudo(Context0),
    Managers = m_rsc:name_to_id_check(acl_user_group_managers, Context),
    Moderators = m_rsc:name_to_id_check(acl_user_group_moderators, Context),
    move_user_group(Managers, Moderators, Context).

% based of m_category move_below functionality for categories
move_user_group(UserGroupId, ParentUserGroupId, Context) ->
    Tree = m_hierarchy:menu(acl_user_group, Context),
    {ok, {Tree1, Node, PrevParentId}} = remove_node(Tree, UserGroupId, undefined),
    case PrevParentId of
        ParentUserGroupId ->
            ok;
        _ ->
            Tree2 = insert_node(ParentUserGroupId, Node, Tree1, []),
            m_hierarchy:save('acl_user_group', Tree2, Context),
            flush(Context)
    end.

remove_node([], _Id, _ParentId) ->
    notfound;
remove_node([{Id,_Cs}=Node|Ts], Id, ParentId) ->
    {ok, {Ts, Node, ParentId}};
remove_node([{TId,TCs}|Ts], Id, ParentId) ->
    case remove_node(TCs, Id, ParentId) of
        {ok, {TCs1,Node,PId}} ->
            {ok, {[{TId,TCs1}|Ts], Node, PId}};
        notfound ->
            case remove_node(Ts, Id, ParentId) of
                {ok, {Ts1,Node,PId}} ->
                    {ok, {[{TId,TCs}|Ts1], Node, PId}};
                notfound ->
                    notfound
            end
    end.

insert_node(undefined, Node, Tree, []) ->
    Tree ++ [Node];
insert_node(_ParentId, _Node, [], Acc) ->
    lists:reverse(Acc);
insert_node(ParentId, Node, [{ParentId,TCs}|Tree], Acc) ->
    lists:reverse(Acc, [{ParentId,TCs++[Node]} | Tree]);
insert_node(ParentId, Node, [{TId,TCs}|Tree], Acc) ->
    T1 = {TId, insert_node(ParentId, Node, TCs, [])},
    insert_node(ParentId, Node, Tree, [T1|Acc]).

flush(Context) ->
    m_hierarchy:flush('acl_user_group', Context),
    z_depcache:flush(acl_user_group, Context).
