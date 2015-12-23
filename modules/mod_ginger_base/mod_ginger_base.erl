%% @author Driebit <info@driebit.nl>
%% @copyright 2015

-module(mod_ginger_base).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger Base").
-mod_description("Ginger Base").
-mod_prio(250).
-mod_depends[mod_content_groups, mod_acl_user_groups].
-mod_schema(1).

-export([
    init/1,
    event/2,
    manage_schema/2,
    observe_custom_pivot/2,
    observe_acl_is_allowed/2,
    observe_search_query/2
]).

-include("zotonic.hrl").

%% @doc Initialize mod_ginger_base
-spec init(#context{}) -> ok.
init(Context) ->
    ginger_config:install_config(Context),
    ginger_acl:install(Context),
    z_pivot_rsc:define_custom_pivot(ginger_search, [{is_unfindable, "boolean not null default false"}], Context).

%% @doc When ACL is enabled, create a default user in the editors group
manage_schema(_Version, Context) ->
    case ginger_acl:is_enabled(Context) of
        false ->
            ok;
        true ->
            Datamodel = #datamodel{
                categories=[
                    {agenda, query, [
                      {title, {trans, [{nl, <<"Agenda">>},
                                       {en, <<"Agenda">>}]}},
                      {language, [en,nl]}
                    ]},
                    {communitymember, person, [
                      {title, {trans, [{nl, <<"Communitylid">>},
                                       {en, <<"Community member">>}]}},
                      {language, [en,nl]}
                    ]}
                ],
                resources = [
                    % {uniquename, category, [
                    %     {propname, propvalue}
                    % ]},
                    {editor_dev, person, [
                        {title, "Redacteur"},
                        {name_first, "Redacteur"},
                        {email, "redactie@ginger.nl"}
                    ]},
                    {fallback, image, [
                        {title, "Fallback image"}
                    ]},
                    {footer_menu, menu, [
                        {title, "Footer menu"}
                    ]},
                    {home, collection, [
                        {title, "Homepage"}
                    ]}
                ],
                predicates = [
                    {subnavigation, [
                      {title, {trans, [{nl, <<"Subnavigatie">>},
                                       {en, <<"Subnavigation">>}]}},
                      {language, [en,nl]}
                      ], [
                      {contentgroup, collection}
                    ]},
                    {hasbanner, [
                      {title, {trans, [{nl, <<"Banner">>},
                                       {en, <<"Banner">>}]}},
                      {language, [en,nl]}
                      ], [
                      {contentgroup, image}
                    ]}
                ],
                edges = [
                    {editor_dev, hasusergroup, acl_user_group_editors}
                ]
            },
            z_datamodel:manage(?MODULE, Datamodel, Context),
            schema:create_identity_if_not_exists(editor_dev, "redacteur", "redacteur", Context)
    end,
    ok.

%% @doc Users without access to the admin should not be able to view unpublished
%%      resources
observe_acl_is_allowed(#acl_is_allowed{action=view, object=Id}, Context) ->
    ginger_acl:can_view(Id, Context);
observe_acl_is_allowed(#acl_is_allowed{}, _Context) ->
    undefined.

%% @doc Handle the submit event of a new comment
event(#submit{message={newcomment, Args}, form=FormId}, Context) ->
    ExtraActions = proplists:get_all_values(action, Args),
    {id, Id} = proplists:lookup(id, Args),
    case z_auth:is_auth(Context) of
        false ->
            Name = z_context:get_q_validated("name", Context),
            Email = z_context:get_q_validated("mail", Context);
        true ->
            Name = "",
            Email = ""
    end,
    Message = z_context:get_q_validated("message", Context),
    Is_visible = case m_config:get_value(comments, moderate, Context) of <<"1">> -> false; _Else -> true end,
    case m_comment:insert(Id, Name, Email, Message, Is_visible, Context) of
        {ok, CommentId} ->
            CommentsListElt = proplists:get_value(comments_list, Args, "comments-list"),
            CommentTemplate = proplists:get_value(comment_template, Args, "_comments_comment.tpl"),
            Comment = m_comment:get(CommentId, Context),
            Props = [
                {id, Id},
                {comment, Comment},
                {creator, m_rsc:p(Id, creator_id, Context)},
                {hidden, true}
            ],
            Html = z_template:render(CommentTemplate, Props, Context),
            Context1 = z_render:insert_bottom(CommentsListElt, Html, Context),
            Context2 = case Is_visible of
			   true ->
             AllActions = lists:merge([
					      {set_value, [{selector, "#"++FormId++" textarea[name=\"message\"]"}, {value, ""}]},
					      {set_value, [{selector, "#"++FormId++" input[name=\"message\"]"}, {value, ""}]},
					      {fade_in, [{target, "comment-"++integer_to_list(CommentId)}]}
					     ], ExtraActions),
			       z_render:wire(AllActions, Context1);
			   false ->
			       Context1
		       end,
            case z_convert:to_bool(proplists:get_value(do_redirect, Args, true)) of
                true -> z_render:wire({redirect, [{location, "#comment-"++integer_to_list(CommentId)}]}, Context2);
                false -> Context2
            end;
        {error, _} ->
            Context
    end;
event(#postback{message={map_infobox, _Args}}, Context) ->
    Ids = z_context:get_q(ids, Context),
    Element = z_context:get_q(element, Context),
    Render = z_template:render("map/map-infobox.tpl", [{results, Ids}], Context),
    EscapedRender = z_utils:js_escape(iolist_to_binary(Render)),
    JS = erlang:iolist_to_binary(
        [
            <<"$('#">>,
            Element,
            <<"').data('ui-googlemap').showInfoWindow(">>,
            z_convert:to_binary(lists:last(Ids)),
            <<", \"">>,
            z_convert:to_binary(EscapedRender),
            <<"\");">>
        ]
    ),
    z_render:wire({script, [{script, JS}]}, Context).

observe_custom_pivot({custom_pivot, Id}, Context) ->
    Excluded = z_convert:to_bool(m_rsc:p(Id, is_unfindable, Context)),
    {ginger_search, [{is_unfindable, Excluded}]}.

observe_search_query(#search_query{search={ginger_search, _Args}}=Q, Context) ->
    ginger_search:search_query(Q, Context);
observe_search_query(#search_query{search={ginger_geo, _Args}}=Q, Context) ->
    ginger_geo_search:search_query(Q, Context);
observe_search_query(#search_query{search={ginger_geo_nearby, _Args}}=Q, Context) ->
    ginger_geo_search:search_query(Q, Context);
observe_search_query(#search_query{}, _Context) ->
    undefined.
