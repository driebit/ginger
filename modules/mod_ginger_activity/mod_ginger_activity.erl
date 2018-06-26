%% @author Driebit <tech@driebit.nl>
%% @copyright 2016

-module(mod_ginger_activity).
-author("Driebit <tech@driebit.nl>").

-mod_title("Ginger activity").
-mod_description("Tracking user activity on resources").

-include_lib("zotonic.hrl").

-mod_prio(500).
-mod_schema(1).

-export([
    manage_schema/2,
    event/2,
    register_activity/2,
    register_activity/3,
    register_activity/4,
    pid_observe_ginger_activity/3
]).

-include("include/ginger_activity.hrl").

-type activity() :: #ginger_activity{}.

-export_type([
    activity/0
]).

-spec manage_schema(pos_integer(), z:context()) -> ok.
manage_schema(_Version, Context) ->
    case z_db:table_exists(activity_log, Context) of
        true ->
            [] = z_db:q("
                 alter table activity_log
                 drop constraint fk_activity_log_rsc_id,
                 add constraint fk_activity_log_rsc_id
                     foreign key (rsc_id)
                     references rsc(id)
                     on delete cascade;
            ", Context),
            [] = z_db:q("
                 alter table activity_log
                 drop constraint if exists fk_activity_log_user_id;

            ", Context),
            ok;
        false ->
            ginger_config:install_config(
                [{mod_ginger_activity, persist_activity, true}],
                Context
            ),
            [] = z_db:q("
                create table activity_log (
                    id SERIAL,
                    rsc_id int not null,
                    time timestamp with time zone not null,
                    user_id int,
                    ip_address character varying(40),

                    constraint activity_log_pkey primary key (id),
                    constraint fk_activity_log_rsc_id foreign key (rsc_id)
                        references rsc(id) on delete cascade
                );
            ", Context),
            [] = z_db:q("
                create index activity_log_rsc_id_index on activity_log (rsc_id);
            ", Context),
            ok
    end,
    m_ginger_activity:init(Context),
    m_ginger_activity_inbox:init(Context),
    ok.

% @doc postback for activating resources
event({postback,{activate, Args}, _TriggerId, _TargetId}, Context) ->
    case m_rsc:rid(proplists:get_value(id, Args), Context) of
        undefined ->
            Context;
        RscId ->
            register_activity(RscId, Context),
            Context
    end.

% @doc logical entry point for registering activity
-spec register_activity(m_rsc:resource() | activity(), z:context()) -> ok.
register_activity(#ginger_activity{} = Activity, Context) ->
    z_notifier:notify({ginger_activity, Activity}, Context),
    ok;
register_activity(Rsc, Context) ->
    register_activity(Rsc, undefined, Context).

-spec register_activity(m_rsc:resource(), m_rsc:resource(), z:context()) -> ok.
register_activity(RscId, Target, Context) ->
    register_activity(RscId, Target, [], Context).

-spec register_activity(m_rsc:resource(), m_rsc:resource(), [integer()], z:context()) -> ok.
register_activity(RscId, Target, Mentions, Context) ->
    Activity = m_ginger_activity:activity(RscId, Context),
    WithTarget = m_ginger_activity:target(Activity, Target),
    WithMentions = m_ginger_activity:to(WithTarget, Mentions),
    z_notifier:notify({ginger_activity, WithMentions}, Context),
    ok.

pid_observe_ginger_activity(_Pid, {ginger_activity, Activity}, Context) ->
    #ginger_activity{rsc_id = RscId} = Activity,
    case z_convert:to_bool(m_config:get_value(mod_ginger_activity, persist_activity, Context)) of
        true ->
            insert_activity(Activity, Context),
            z_pivot_rsc:pivot(RscId, Context),
            ok;
        false ->
            ok
    end.

-spec insert_activity(activity(), z:context()) -> ok.
insert_activity(Activity, Context) ->
    #ginger_activity{
        rsc_id = Rsc,
        target_id = Target,
        to = To,
        time = Time,
        user_id = User,
        ip_address = Ip
    } = Activity,

    Props = [
        {rsc_id, Rsc},
        {target_id, Target},
        {to_ids, ?DB_PROPS(To)},
        {time, Time},
        {user_id, User},
        {ip_address, Ip}
    ],
    {ok, Id} = z_db:insert(activity_log, Props, Context),
    ActivityWithId = Activity#ginger_activity{id = Id},
    z_notifier:notify_sync(#ginger_activity_inserted{activity = ActivityWithId}, Context),
    ok.
