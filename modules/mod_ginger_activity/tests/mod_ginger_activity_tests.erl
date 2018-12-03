-module(mod_ginger_activity_tests).

-include_lib("eunit/include/eunit.hrl").
-include_lib("../include/ginger_activity.hrl").
-include_lib("zotonic.hrl").

fan_out_test() ->
    Context = context(),
    Sudo = z_acl:sudo(Context),

    %% Prepare data.
    {ok, Thing} = m_rsc:insert(
        [
            {category, text},
            {title, <<"Something interesting">>}
        ],
        Sudo
    ),
    {ok, Collection} = m_rsc:insert(
        [
            {category, collection},
            {title, <<"Collection of interesting things">>}
        ],
        Sudo
    ),
    {ok, _} = m_edge:insert(Collection, haspart, Thing, Sudo),

    {ok, Activist} = m_rsc:insert(
        [
            {category, person},
            {title, <<"I make activities happen">>}
        ],
        Sudo
    ),

    {ok, InterestedUser} = m_rsc:insert(
        [
            {category, person},
            {title, <<"I'm very interested in activities">>}
        ],
        Sudo
    ),

    %% Have user Activist create an activity record.
    ActivistContext = z_acl:logon(Activist, Context),
    Activity = m_ginger_activity:activity(Thing, ActivistContext),
    WithTarget = m_ginger_activity:target(Activity, Collection),

    InterestedUsers = [InterestedUser],
    WithTo = m_ginger_activity:to(WithTarget, InterestedUsers),

    %% Log that activity itself.
    ok = mod_ginger_activity:register_activity(WithTo, z_context:prune_for_spawn(Context)),

    %% Then let observe_ginger_activity_inserted/2 (below) fan out the activity to interested users'
    %% inboxes.
    z_notifier:observe(ginger_activity_inserted, self(), Context),

    wait_for_observer(),

    %% Check InterestedUser's inbox to make sure the activity has been logged.
    [
        #ginger_activity{
            rsc_id = LoggedRsc,
            target_id = LoggedTarget,
            to = LoggedTo,
            user_id = LoggedUser
        }
    ] = m_ginger_activity_inbox:for_user(InterestedUser, Context),

    [
        ?assertEqual(Thing, LoggedRsc),
        ?assertEqual(Collection, LoggedTarget),
        ?assertEqual(InterestedUsers, LoggedTo),
        ?assertEqual(Activist, LoggedUser)
    ].

context() ->
    Context = z_context:new(testsandboxdb),
    start_modules(Context).

start_modules(Context) ->
    ok = z_module_manager:activate_await(mod_ginger_activity, Context),
    Context.

wait_for_observer() ->
    receive
        {'$gen_cast', {#ginger_activity_inserted{} = Notification, Context}} ->
            observe_ginger_activity_inserted(Notification, Context);
        Msg ->
            lager:error("Did not expect message ~p", [Msg]),
            ?assert(false)
    after 10000 ->
        lager:error("Did not receive #ginger_activity_inserted{} message"),
        ?assert(false)
    end.

observe_ginger_activity_inserted(#ginger_activity_inserted{activity = Activity}, Context) ->
    #ginger_activity{to = To} = Activity,
    ok = m_ginger_activity_inbox:fan_out(Activity, To, Context).
