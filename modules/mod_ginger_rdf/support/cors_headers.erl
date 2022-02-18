-module(cors_headers).

-export([
    allow_all_cors/1
]).

%% @doc Unlike controller_api:set_cors_header, this function doesn't look at the configuration but unconditionally
%% exposes this controller between domains. This makes sharing content much easier.
allow_all_cors(Context) ->
    lists:foldl(
        fun({K, Def}, Acc) ->
            case m_config:get_value(site, K, Def, Context) of
                undefined ->
                    Acc;
                V ->
                    z_context:set_resp_header(atom_to_list(K), V, Acc)
            end
        end,
        Context,
        [
            {'Access-Control-Allow-Origin', "*"},
            {'Access-Control-Max-Age', undefined}
        ]
    ).
