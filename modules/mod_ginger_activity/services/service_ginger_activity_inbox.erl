%% @doc Retrieve activity notifications.
-module(service_ginger_activity_inbox).

-svc_needauth(true).

-export([
    process_post/2,
    process_get/2
]).

-include_lib("zotonic.hrl").
-include_lib("../include/ginger_activity.hrl").

%% @doc Get activity stream inbox for a user.
process_get(_ReqData, Context) ->
    Activities = m_ginger_activity_inbox:for_user(z_acl:user(Context), Context),
    Json = #{
        <<"@context">> => <<"https://www.w3.org/ns/activitystreams">>,
        <<"type">> => <<"Collection">>,
        <<"items">> => [to_json(A, Context) || A <- Activities]
    },
    jsx:encode(Json).

%% @doc Record when the inbox items were last seen by the user.
process_post(#wm_reqdata{method = 'POST'}, Context) ->
    User = z_acl:user(Context),
    DateTime = z_datetime:to_datetime(z_context:get_q(seen_at, Context)),
    m_ginger_activity_inbox:update_seen_at_for_user(User, DateTime, Context),
    <<>>;

%% @doc Delete an item from the user's activity stream inbox.
process_post(#wm_reqdata{method = 'DELETE'}, Context) ->
    User = z_acl:user(Context),
    case z_context:get_q(id, Context) of
        undefined ->
            %% Delete complete user's activity stream.
            m_ginger_activity_inbox:delete(User, Context);
        Id ->
            IntId = z_convert:to_integer(Id),
            m_ginger_activity_inbox:delete(User, IntId, Context)
    end,
    <<>>.

-spec to_json(#ginger_activity{}, z:context()) -> map().
to_json(Activity, Context) ->
    #ginger_activity{
        id = Id,
        user_id = Actor,
        rsc_id = Object,
        target_id = Target,
        time = Time
    } = Activity,
    Map = #{
        <<"id">> => url(activity_notification, [{id, Id}], Context),
        <<"type">> => <<"Activity">>,
        <<"published">> => Time,
        <<"actor">> => #{
            <<"type">> => <<"Person">>,
            <<"name">> => z_trans:trans(m_rsc:p(Actor, title, Context), Context)
        },
        <<"object">> => #{
            <<"id">> => m_rsc:p(Object, page_url_abs, Context),
            <<"type">> => m_rsc:p(m_rsc:p(Object, category_id, Context), name, Context),
            <<"name">> => z_trans:trans(m_rsc:p(Object, title, Context), Context),
            <<"content">> => content(Object, Context)
        }
    },
    with_target(Target, Map, Context).

with_target(undefined, Activity, _Context) ->
    Activity;
with_target(Target, Activity, Context) ->
    Activity#{
        <<"target">> => #{
            <<"id">> => m_rsc:p(Target, page_url_abs, Context),
            <<"type">> => m_rsc:p(m_rsc:p(Target, category_id, Context), name, Context),
            <<"name">> => z_trans:trans(m_rsc:p(Target, title, Context), Context)
        }
    }.

content(Rsc, Context) ->
    z_string:truncate(
        z_trans:trans(
            m_rsc:p(Rsc, body, Context),
            Context
        ),
        200
    ).

url(DispatchRule, Props, Context) ->
    z_dispatcher:url_for(DispatchRule, [use_absolute_url | Props], Context).
