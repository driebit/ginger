%% @author Driebit <tech@driebit.nl>
%% @copyright 2016

-module(mod_ginger_activity).
-author("Driebit <tech@driebit.nl>").

-mod_title("Ginger activity").
-mod_description("Tracking user activity on resources").

-include_lib("zotonic.hrl").

-mod_prio(500).

-export([
    init/1,
    event/2,
    register_activity/2,
    pid_observe_ginger_activity/3
]).

-include("include/ginger_activity.hrl").

init(Context) ->
    case z_db:table_exists(activity_log, Context) of
        true ->
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
                        references rsc(id),
                    constraint fk_activity_log_user_id foreign key (user_id)
                        references rsc(id)
                );
            ", Context),
            [] = z_db:q("
                create index activity_log_rsc_id_index on activity_log (rsc_id);
            ", Context),
            ok
    end.    

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
register_activity(RscId, Context) ->
    Time = calendar:universal_time(),
    UserId = z_acl:user(Context),
    IpAddress = case z_context:get_reqdata(Context) of
        undefined -> undefined;
        Value -> z_convert:to_binary(wrq:peer(Value))
    end,
    Entry = #entry{rsc_id = RscId, time = Time, user_id = UserId, ip_address = IpAddress},
    z_notifier:notify({ginger_activity, Entry}, Context),
    ok.
    
pid_observe_ginger_activity(_Pid, {ginger_activity, Entry}, Context) ->
    #entry{rsc_id = RscId, time = Time, user_id = UserId, ip_address = IpAddress} = Entry,
    case z_convert:to_bool(m_config:get_value(mod_ginger_activity, persist_activity, Context)) of
        true ->
            insert_activity(RscId, Time, UserId, IpAddress, Context),
            z_pivot_rsc:pivot(RscId, Context),
            ok;
        false ->
            ok
    end.
    
% @doc single entry point for inserting activity into the database
% insert_activity(RscId, Context) ->
%     insert_activity(RscId, calendar:local_time(), Context).
% insert_activity(RscId, DateTime, Context) ->
%     insert_activity(RscId, DateTime, undefined, Context).
% insert_activity(RscId, DateTime, UserId, Context) ->
%     insert_activity(RscId, DateTime, UserId, undefined, Context).
insert_activity(RscId, DateTime, UserId, IpAddress, Context) ->
    Props = [{rsc_id, RscId}, {time, DateTime}, {user_id, UserId}, {ip_address, IpAddress}],
    z_db:insert(activity_log, Props, Context).  