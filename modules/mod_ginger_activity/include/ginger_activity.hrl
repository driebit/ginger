
-record(entry, {
        rsc_id :: pos_integer(),
        time :: tuple(),
        user_id=undefined :: pos_integer() | undefined,
        ip_address=undefined :: binary() | undefined
}).
