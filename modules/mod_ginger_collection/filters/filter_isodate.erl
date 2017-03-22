%% @doc A date filter for ISO datetimes (instead of datetime tuples).
%%      If a year is passed <<"2017">>, that year is printed. Other inputs are
%%      converted to a datetime tuple set and passed to Zotonic's date filter.
-module(filter_isodate).

-export([
    isodate/3
]).

-include_lib("zotonic.hrl").

isodate(Datetime, Format, Context) ->
    case z_utils:only_digits(Datetime) of
        true ->
            Datetime;
        _ ->
            Tuples = z_datetime:to_datetime(Datetime),
            filter_date:date(Tuples, Format, Context)
    end.
