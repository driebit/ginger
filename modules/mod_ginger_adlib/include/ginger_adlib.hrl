%% @doc Notification that some new/updated data is available in Adlib
-record(adlib_update, {
    date :: {{pos_integer(), pos_integer(), pos_integer()}, {pos_integer(), pos_integer(), pos_integer()}},
    record :: map(),
    database :: binary()
}).
