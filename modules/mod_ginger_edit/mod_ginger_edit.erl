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


%% overrule mod_admin for using ginger_edit templates
event(#postback_notify{message="feedback", trigger="ginger-dialog-connect-find", target=TargetId}, Context) ->
    % Find pages matching the search criteria.
    SubjectId = z_convert:to_integer(z_context:get_q(subject_id, Context)),
    ObjectId = z_convert:to_integer(z_context:get_q(object_id, Context)),
    Category = z_context:get_q(find_category, Context),
    CatExclude = z_context:get_q(cat_exclude, Context),
    Predicate = z_context:get_q(predicate, Context, ""),
    Text = z_context:get_q(find_text, Context),
    Cats = case Category of
                "p:"++Predicate -> mod_admin:feedback_categories(SubjectId, Predicate, ObjectId, Context);
                <<"p:", Predicate/binary>> -> mod_admin:feedback_categories(SubjectId, Predicate, ObjectId, Context);
                "" -> [];
                <<>> -> [];
                Cat -> [Cat]
           end,
    Vars = [
        {subject_id, SubjectId},
        {cat, Cats},
        {cat_exclude, CatExclude},
        {predicate, Predicate},
        {text, Text}
    ] ++ case z_context:get_q(find_cg, Context) of
        <<>> -> [];
        "" -> [];
        undefined -> [];
        <<"me">> -> [ {creator_id, z_acl:user(Context)} ];
        "me" -> [ {creator_id, z_acl:user(Context)} ];
        CgId -> [ {content_group, m_rsc:rid(CgId, Context)}]
    end,
    z_render:wire([
        {remove_class, [{target, TargetId}, {class, "loading"}]},
        {update, [{target, TargetId}, {template, "_action_ginger_dialog_connect_tab_find_results.tpl"} | Vars]}
    ], Context);

%% @doc Custom version of controller_admin_edit rscform that executes actions instead of redirecting
event(#submit{message=rscform} = Msg, Context) ->
    event(Msg#submit{message={rscform, []}}, Context);
event(#submit{message={rscform, Args}}, Context) ->
    Post = z_context:get_q_all_noz(Context),
    Props = controller_admin_edit:filter_props(Post),
    Id = z_convert:to_integer(proplists:get_value("id", Props)),
    Props1 = proplists:delete("id", Props),
    Props2 = z_notifier:foldl(#admin_rscform{id=Id, is_a=m_rsc:is_a(Id, Context)}, Props1, Context),
    try
        {ok, _} = m_rsc:update(Id, Props2, Context),
        SuccessActions = proplists:get_all_values(on_success, Args),
        z_render:wire(SuccessActions, Context)
    catch
        throw:{error, duplicate_uri} ->
            z_render:growl_error("Error, duplicate uri. Please change the uri.", Context);
        throw:{error, duplicate_page_path} ->
            z_render:growl_error("Error, duplicate page path. Please change the uri.", Context);
        throw:{error, duplicate_name} ->
            z_render:growl_error("Error, duplicate name. Please change the name.", Context);
        throw:{error, eacces} ->
            z_render:growl_error("You don't have permission to edit this page.", Context);
        throw:{error, invalid_query} ->
            z_render:growl_error("Your search query is invalid. Please correct it before saving.", Context);
        throw:{error, Message} when is_list(Message); is_binary(Message) ->
            z_render:growl_error(Message, Context);
        X:Y ->
            Stacktrace = erlang:get_stacktrace(),
            lager:error("Rsc update error: ~p:~p stacktrace: ~p", [X, Y, Stacktrace]),
            z_render:growl_error("Something went wrong. Sorry.", Context)
    end.

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
        
