-module(cors_headers).

-export([
    allow_all_cors/1
]).

-include_lib("zotonic.hrl").

%% @doc Unlike controller_api:set_cors_header, this function doesn't look at the configuration but unconditionally
%% exposes the context between domains. This makes sharing content much easier.
-spec allow_all_cors(z:context()) -> z:context().
allow_all_cors(Context) ->
    z_context:set_cors_headers(
        [
            {"Access-Control-Allow-Origin", "*"}
        ],
        Context
    ).
