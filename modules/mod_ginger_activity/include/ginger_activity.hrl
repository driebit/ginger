-record(ginger_activity, {
    id :: pos_integer() | undefined,
    rsc_id :: m_rsc:resource(),
    target_id :: m_rsc:resource() | undefined, %% Object to which the activity is directed.
    time :: tuple(),
    user_id = undefined :: m_rsc:resource() | undefined,
    ip_address = undefined :: binary() | undefined
}).

-record(ginger_activity_inserted, {
    activity = #ginger_activity{}
}).
