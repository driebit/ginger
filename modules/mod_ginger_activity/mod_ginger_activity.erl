%% @author Driebit <tech@driebit.nl>
%% @copyright 2016

-module(mod_ginger_activity).
-author("Driebit <tech@driebit.nl>").

-mod_title("Ginger activity").
-mod_description("Tracking user activity on resources").

-include_lib("zotonic.hrl").

-mod_prio(500).

-export([init/1]).

-compile([export_all]).

init(Context) ->
    case z_db:table_exists(activity_log, Context) of
        true ->
            ok;
        false ->
            [] = z_db:q("
                create table activity_log (
                    id SERIAL,
                    rsc_id int not null,
                    time timestamp with time zone not null,
                    user_id int,
                    
                    constraint activity_log_pkey primary key (id),
                    constraint fk_activity_log_rsc_id foreign key (rsc_id)
                        references rsc(id),
                    constraint fk_activity_log_user_id foreign key (user_id)
                        references rsc(id)
                )
            ", Context),
            % TODO: Some indexes
            ok
    end.

% @doc single entry point for inserting activity into the database
insert_activity(RscId, Context) ->
    insert_activity(RscId, calendar:local_time(), Context).
insert_activity(RscId, DateTime, Context) ->
    insert_activity(RscId, DateTime, undefined, Context).
insert_activity(RscId, DateTime, UserId, Context) ->
    Props = [{rsc_id, RscId}, {time, DateTime}, {user_id, UserId}],
    z_db:insert(activity_log, Props, Context).

% @doc logical entry point for registering activity
register_activity(RscId, Context) ->
    Time = calendar:local_time(),
    UserId = z_acl:user(Context),
    insert_activity(RscId, Time, UserId, Context).

% @doc postback for activating resources
event({postback, activate, _TriggerId, _TargetId}, Context) ->
    case m_rsc:rid(z_context:get_q(id, Context), Context) of
        undefined ->
            Context;
        RscId ->
            register_activity(RscId, Context),
            Context
    end.
