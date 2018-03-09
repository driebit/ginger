%% Handle.net client
%% @see https://www.handle.net/hnr_documentation.html
-module(ginger_handle_net).

-export([
    handle/2,
    put_handle/2,
    put_handle/3
]).

-include_lib("zotonic.hrl").

-record(handle_net_handle, {
    handle :: binary(),
    type = url :: atom(),
    value :: binary()
}).

-record(handle_net_config, {
    api_url :: binary(),
    prefix :: binary(),
    certificate :: binary(),
    key :: binary()
}).

-opaque(config() :: #handle_net_config{}).
-opaque(handle() :: #handle_net_handle{}).

-export_type([
    config/0,
    handle/0
]).

%% @doc Create a handle for registration.
-spec handle(binary(), binary()) -> handle().
handle(Handle, TargetUrl) ->
    #handle_net_handle{
        handle = Handle,
        type = url,
        value = TargetUrl
    }.

%% @doc Register a handle with default config.
-spec put_handle(handle(), z:context()) -> tuple().
put_handle(#handle_net_handle{} = Handle, Context) ->
    put_handle(
        #handle_net_config{
            api_url = m_config:get_value(?MODULE, handle_net_api_url, Context),
            prefix = m_config:get_value(?MODULE, handle_net_prefix, Context),
            certificate = m_config:get_value(?MODULE, handle_net_certificate_file, Context),
            key = m_config:get_value(?MODULE, handle_net_key_file, Context)
        },
        Handle,
        Context
    ).

%% @doc Register a handle with config.
-spec put_handle(config(), handle(), z:context()) -> tuple().
put_handle(#handle_net_config{} = Config, #handle_net_handle{handle = Suffix} = Handle, _Context) ->
    {ApiUrl, Prefix, CertificateFile, KeyFile} = config(Config),
    Data = data(Handle, Prefix),
    Url = <<ApiUrl/binary, "/api/handles/", Prefix/binary, "/", Suffix/binary>>,
    request(Url, Data, CertificateFile, KeyFile).

%% @doc Execute request to API.
-spec request(binary(), map(), binary(), binary()) -> tuple().
request(Url, Data, CertificateFile, KeyFile) ->
    Headers = [
        {"Authorization", "Handle clientCert=\"true\""}
    ],
    SSL = ssl_options(CertificateFile, KeyFile),
    
    case httpc:request(put, {binary_to_list(Url), Headers, "application/json", jsx:encode(Data)}, [{ssl, SSL}], []) of
        {ok, {{_, StatusCode, _}, _Headers, Body}} when StatusCode < 400 ->
            #{<<"handle">> := Handle} = jsx:decode(list_to_binary(Body)),
            {ok, Handle};
        {ok, {{_, StatusCode, _}, _Headers, Body}} ->
            lager:error("ginger_handle_net: Error when registering handle ~p at ~s: ~p ~s", [Data, Url, StatusCode, Body]),
            {error, StatusCode};
        {error, Reason} ->
            lager:error("ginger_handle_net: Error when registering handle ~p at ~s: ~p", [Data, Url, Reason]),
            {error, Reason}
    end.

%% @doc Get SSL options for authentication against API.
-spec ssl_options(binary(), binary()) -> proplists:proplist().
ssl_options(CertificateFile, KeyFile) ->
    {ok, PemBin} = file:read_file(KeyFile),
    {Type, Encoded, _} = hd(public_key:pem_decode(PemBin)),
    [
        {certfile, CertificateFile},
        {key, {Type, Encoded}}
    ].

%% @doc Extract config into tuple.
-spec config(#handle_net_config{}) -> tuple().
config(
    #handle_net_config{
        api_url = ApiUrl,
        prefix = Prefix,
        certificate = CertificateFile,
        key = KeyFile
    }) ->
    {ApiUrl, Prefix, CertificateFile, KeyFile}.

%% @doc Create HTTP request payload.
-spec data(#handle_net_handle{}, binary()) -> map().
data(#handle_net_handle{type = url, value = TargetUrl}, Prefix) ->
    #{
        <<"values">> => [
            #{
                <<"index">> => 1,
                <<"type">> => <<"URL">>,
                <<"data">> => #{
                    <<"format">> => <<"string">>,
                    <<"value">> => TargetUrl
                }
            },
            #{
                <<"index">> => 100,
                <<"type">> => <<"HS_ADMIN">>,
                <<"data">> => #{
                    <<"format">> => <<"admin">>,
                    <<"value">> => #{
                        <<"handle">> => <<"0.NA/", Prefix/binary>>,
                        <<"index">> => 200,
                        <<"permissions">> => <<"011111110011">>
                    }
                }
            }
        ]
    }.
