%% @doc Backwards compatibility.
-module(filter_isodate).

-export([
    isodate/3
]).

-include_lib("zotonic.hrl").

isodate(Datetime, Format, Context) ->
    filter_iso8601:iso8601(Datetime, Format, Context).
