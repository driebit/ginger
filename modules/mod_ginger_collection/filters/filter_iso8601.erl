%% @doc A date filter for ISO 8601 datetimes (instead of datetime tuples).
%%      If a year is passed <<"2017">>, that year is printed. Other inputs are
%%      converted to a datetime tuple set and passed to Zotonic's date filter.
-module(filter_iso8601).

-export([
    iso8601/2,
    iso8601/3
]).

-include_lib("zotonic.hrl").

iso8601(undefined, _Context) ->
    undefined;
iso8601(null, _Context) ->
    undefined;
iso8601(Duration, _Context) ->
    %% See https://en.wikipedia.org/wiki/ISO_8601#Durations
    case re:run(Duration, <<"PT(?:(\\d+)H)?(?:(\\d+)M)?(?:(\\d+)S)?">>, [global, {capture, all_but_first, binary}]) of
        {match, [[<<>>, <<>>, Seconds]]} ->
            <<"0:", Seconds/binary>>;
        {match, [[<<>>, Minutes, Seconds]]} ->
            <<Minutes/binary, ":", Seconds/binary>>;
        {match, [[Hours, Minutes, Seconds]]} ->
            <<Hours/binary, ":", Minutes/binary, ":", Seconds/binary>>;
        nomatch ->
            undefined
    end.

iso8601(undefined, _Format, _Context) ->
    undefined;
iso8601(null, _Format, _Context) ->
    undefined;
iso8601(<<"-", Datetime/binary>>, Format, Context) ->
    %% Year < 0
    case z_utils:only_digits(Datetime) of
        true ->
            %% Year only
            Year = z_convert:to_integer(Datetime),
            filter_date:date({{-Year, 1, 1}, {0, 0, 0}}, year_format(Format), Context);
        false ->
            %% Full date
            {{Y, M, D}, T} = z_datetime:to_datetime(Datetime),
            filter_date:date({{-Y, M, D}, T}, Format, Context)
    end;
iso8601(Datetime, Format, Context) ->
    %% Year >= 0
    case z_utils:only_digits(Datetime) of
        true ->
            Datetime;
        _ ->
            Tuples = z_datetime:to_datetime(Datetime),
            filter_date:date(Tuples, Format, Context)
    end.

year_format(<<"x">>) ->
    <<"x">>;
year_format(_) ->
    %% Default year format includes era
    <<"Y e">>.
