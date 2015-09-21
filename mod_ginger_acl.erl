-module(mod_ginger_acl).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger acl module").
-mod_description("Provides extra ACL rules").
-mod_prio(300).

-include_lib("zotonic.hrl").

-export([
    observe_acl_is_allowed/2
]).


observe_acl_is_allowed(#acl_is_allowed{object=#acl_edge{predicate=hasusergroup}}, _Context) ->
    undefined;
observe_acl_is_allowed(#acl_is_allowed{object=#acl_edge{subject_id = SubjectId}}, Context) ->
    can_author_edit(m_edge:objects(SubjectId, author, Context), Context);
observe_acl_is_allowed(#acl_is_allowed{action=update, object=Id}, Context) ->
    can_author_edit(m_edge:objects(Id, author, Context), Context);
observe_acl_is_allowed(#acl_is_allowed{}, _Context) ->
    undefined.

%% @doc A user can edit when he/she is 1 of the authors
can_author_edit(Authors, #context{user_id=UserId} = _Context) when is_integer(UserId) ->
    case lists:member(UserId, Authors) of
        true -> true;
        false -> undefined
    end;
can_author_edit(_Authors, #context{} = _Context) ->
    undefined.
