-module(m_ginger_activity_inbox).

-export([
    init/1,
    fan_out/3,
    for_user/2,
    delete/2,
    delete/3,
    count_for_user/2,
    seen_at_for_user/2,
    update_seen_at_for_user/3,
    most_recent_at_for_user/2
]).

-include_lib("zotonic.hrl").
-include_lib("../include/ginger_activity.hrl").

%% @doc Get all activity notifications in a user's inbox.
-spec for_user(m_rsc:resource(), z:context()) -> [mod_ginger_activity:activity()].
for_user(UserId, Context) ->
    Activities = z_db:assoc("
        select
            activity_log.id,
            activity_log.rsc_id,
            activity_log.time,
            activity_log.target_id,
            activity_log.to_ids,
            activity_log.user_id as user_id
        from activity_inbox
        left join activity_log on activity_log.id = activity_inbox.activity_id
        where activity_inbox.user_id = $1",
        [UserId],
        Context
    ),
    [ginger_activity(A) || A <- Activities].

-spec count_for_user(m_rsc:resource(), z:context()) -> integer().
count_for_user(User, Context) ->
    z_db:q1("select count(user_id) from " ++ table() ++ " where user_id = $1;",
        [z_convert:to_integer(User)], Context).

-spec seen_at_for_user(m_rsc:resource(), z:context()) -> calendar:datetime() | undefined.
seen_at_for_user(User, Context) ->
    m_rsc:p(User, notifications_seen_at, Context).

-spec update_seen_at_for_user(m_rsc:resource(), calendar:datetime(), z:context()) -> ok.
update_seen_at_for_user(User, DateTime, Context) ->
    m_rsc:update(User, [ {notifications_seen_at, DateTime} ], Context).

-spec most_recent_at_for_user(m_rsc:resource(), z:context()) -> calendar:datetime() | undefined.
most_recent_at_for_user(User, Context) ->
    z_db:q1("
        select max(activity_log.time) from activity_inbox
        left join activity_log on activity_log.id = activity_inbox.activity_id
        where activity_inbox.user_id = $1",
        [z_convert:to_integer(User)], Context).

%% @doc Delete all activities from the user's stream.
-spec delete(m_rsc:resource(), z:context()) -> ok.
delete(UserId, Context) ->
    z_db:q("delete from " ++ table() ++
        " where user_id = $1",
        [UserId],
        Context
    ),
    ok.

%% @doc Delete a single activity from the user's stream.
-spec delete(m_rsc:resource(), pos_integer(), z:context()) -> ok.
delete(UserId, ActivityId, Context) ->
    z_db:q("delete from " ++ table() ++
        " where user_id = $1 and activity_id = $2",
        [UserId, ActivityId],
        Context
    ),
    ok.

%% @doc Add an activity to users' activity stream inbox.
-spec fan_out(#ginger_activity{}, [m_rsc:resource()], z:context()) -> ok.
fan_out(#ginger_activity{id = Id}, Users, Context) ->
    [insert(Id, User, Context) || User <- Users],
    ok.

init(Context) ->
    ensure_table(Context).

%% @doc Ensure the database table exists.
-spec ensure_table(z:context()) -> ok.
ensure_table(Context) ->
    case z_db:table_exists(table(), Context) of
        true ->
            ok;
        false ->
            [] = z_db:q("
                create table " ++ table() ++ "(
                    activity_id int not null,
                    user_id int not null,
                    constraint " ++ table() ++ "_pkey primary key (activity_id, user_id),
                    constraint fk_" ++ table() ++ "_activity_id
                        foreign key (activity_id)
                        references activity_log (id)
                        on delete cascade,
                    constraint fk_" ++ table() ++ "_user_id
                        foreign key (user_id)
                        references rsc (id)
                        on delete cascade
                );",
                Context
            ),
            ok
    end.

insert(ActivityId, UserId, Context) ->
    {ok, _} = z_db:insert(
        table(),
        [
            {activity_id, ActivityId},
            {user_id, UserId}
        ],
        Context
    ),
    Topic = <<"~site/user/", (z_convert:to_binary(UserId))/binary, "/activities">>,
    ok = z_mqtt:publish(Topic, ActivityId, z_acl:sudo(Context)).

table() ->
    "activity_inbox".

-spec ginger_activity(proplists:proplist()) -> #ginger_activity{}.
ginger_activity(Props) ->
    #ginger_activity{
        id = proplists:get_value(id, Props),
        user_id = proplists:get_value(user_id, Props),
        rsc_id = proplists:get_value(rsc_id, Props),
        time = proplists:get_value(time, Props),
        target_id = proplists:get_value(target_id, Props),
        to = proplists:get_value(to_ids, Props)
    }.
