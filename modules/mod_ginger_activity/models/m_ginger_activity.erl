-module(m_ginger_activity).

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2,
    rsc_count/2,
    activity/2,
    target/2,
    to/2,
    init/1
]).

-include_lib("zotonic.hrl").
-include_lib("../include/ginger_activity.hrl").

%% @doc Initialize the database.
-spec init(z:context()) -> ok.
init(Context) ->
    ensure_target_column(Context),
    ensure_to_column(Context).

rsc_count(RscId, Context) ->
    z_db:q1("select count(id) from activity_log where rsc_id = $1;",
            [z_convert:to_integer(RscId)], Context).

%% @doc Create a new activity.
-spec activity(m_rsc:resource(), z:context()) -> mod_ginger_activity:activity().
activity(Rsc, Context) ->
    #ginger_activity{
        rsc_id = Rsc,
        time = calendar:universal_time(),
        user_id = z_acl:user(Context),
        ip_address = ip_address(Context)
    }.

%% @doc Address activity to a public primary audience.
%%      See https://www.w3.org/TR/activitystreams-vocabulary/
-spec to(mod_ginger_activity:activity(), [m_rsc:resource()]) -> mod_ginger_activity:activity().
to(#ginger_activity{} = Activity, To) ->
    Activity#ginger_activity{to = To}.

%% @doc Direct activity to a target.
-spec target(mod_ginger_activity:activity(), m_rsc:resource()) -> mod_ginger_activity:activity().
target(#ginger_activity{} = Activity, Target) ->
    Activity#ginger_activity{target_id = Target}.

% Syntax: m.activity[RscId]
m_find_value(RscId, #m{value=undefined} = M, _Context) ->
    M#m{value=[RscId]};

% Syntax: m.activity[RscId].count
m_find_value(count, #m{value=[RscId]}, Context) ->
    rsc_count(RscId, Context).

m_to_list(_, _Context) ->
    [].

m_value(_, _Context) ->
    undefined.

ensure_target_column(Context) ->
    case lists:member(target_id, z_db:column_names(activity_log, Context)) of
        true ->
            ok;
        false ->
            [] = z_db:q("
                alter table activity_log
                    add column target_id int,
                    add constraint fk_activity_log_target_id
                        foreign key (target_id)
                        references rsc (id)
                        on delete cascade
                ;",
                Context
            ),
            ok
    end.

ensure_to_column(Context) ->
    case lists:member(to_ids, z_db:column_names(activity_log, Context)) of
        true ->
            ok;
        false ->
            [] = z_db:q("alter table activity_log add column to_ids bytea;", Context),
            ok
    end.

ip_address(Context) ->
    case z_context:get_reqdata(Context) of
        undefined -> undefined;
        Value ->
            case proplists:get_value("x-forwarded-for", wrq:req_headers(Value)) of
                undefined ->
                    z_convert:to_binary(wrq:peer(Value));
                Hosts ->
                    z_convert:to_binary(string:strip(lists:last(string:tokens(Hosts, ","))))
            end
    end.
