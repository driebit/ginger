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
                    ip_address character varying(40),

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
    insert_activity(RscId, DateTime, UserId, undefined, Context).
insert_activity(RscId, DateTime, UserId, IpAddress, Context) ->
    Props = [{rsc_id, RscId}, {time, DateTime}, {user_id, UserId}, {ip_address, IpAddress}],
    z_db:insert(activity_log, Props, Context).

% @doc logical entry point for registering activity
register_activity(RscId, Context) ->
    Time = calendar:local_time(),
    UserId = z_acl:user(Context),
    IpAddress = case z_context:get_reqdata(Context) of
        undefined -> undefined;
        Value -> wrq:peer(Value)
    end,
    insert_activity(RscId, Time, UserId, IpAddress, Context),
    z_pivot_rsc:pivot(RscId, Context), % Might want to find a better solution
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
