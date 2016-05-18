-module(mod_ginger_edit).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger frontend edit module").
-mod_description("Provides Ginger frontend editing and adding dialogs").
-mod_prio(200).

-include_lib("zotonic.hrl").

-export([
    is_authorized/2,
    event/2,
    observe_admin_rscform/3
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

%% @doc Attempt to add edges defined as form fields
observe_admin_rscform(#admin_rscform{id=RscId}, Props, Context) ->
    lists:filter(fun({[$o, $b, $j, $e, $c, $t, $| |Pred], ObjectId}) ->
                        maybe_edge(RscId, Pred, ObjectId, Context),
                        false;
                    ({[$s, $u, $b, $j, $e, $c, $t, $| |Pred], SubjectId}) ->
                        maybe_edge(SubjectId, Pred, RscId, Context),
                        false;
                    (_) -> true
                 end, Props).

maybe_edge(SubjectId, PredStr, ObjectId, Context) ->
    Pred = z_convert:to_atom(PredStr),
    Subject = m_rsc:rid(SubjectId, Context),
    Object  = m_rsc:rid(ObjectId, Context),
    case {Subject, Object} of
        {undefined, _} -> ok;
        {_, undefined} -> ok;
        {_, _} -> m_edge:insert(Subject, Pred, Object, Context)
    end.
