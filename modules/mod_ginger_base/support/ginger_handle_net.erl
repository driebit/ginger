%% Handle.net client
%% @see https://www.handle.net/hnr_documentation.html
-module(ginger_handle_net).

-export([
    handle/2,
    put_handle/2
]).

%% Total request timeout
-define(HTTPC_TIMEOUT, 20000).

%% Connect timeout, server has to respond before this
-define(HTTPC_TIMEOUT_CONNECT, 10000).

-include_lib("zotonic.hrl").

-record(handle_net_handle, {
    handle :: binary(),
    type = url :: atom(),
    value :: binary()
}).

-opaque(handle() :: #handle_net_handle{}).

-export_type([
    handle/0
]).

%% @doc Create a handle for registration.
-spec handle(Handle, TargetUrl) -> handle() when
    Handle :: binary(),
    TargetUrl :: binary().
handle(Handle, TargetUrl) ->
    #handle_net_handle{
        handle = Handle,
        type = url,
        value = TargetUrl
    }.

%% @doc Register a handle with default config.
-spec put_handle(handle(), z:context()) -> {ok, Handle} | {error, Reason} when
    Handle :: binary(),
    Reason :: term().
put_handle(#handle_net_handle{ handle = Suffix } = Handle, Context) ->
    ApiUrl = m_config:get_value(?MODULE, handle_net_api_url, Context),
    Prefix = m_config:get_value(?MODULE, handle_net_prefix, Context),
    CertificateFile = m_config:get_value(?MODULE, handle_net_certificate_file, Context),
    KeyFile = m_config:get_value(?MODULE, handle_net_key_file, Context),
    Data = data(Handle, Prefix),
    Url = <<
        ApiUrl/binary,
        "/api/handles/",
        Prefix/binary,
        "/",
        Suffix/binary>>,
    request(
        Url,
        Data,
        CertificateFile,
        KeyFile).

%% @doc Execute request to API.
-spec request(Url, Data, CertificateFile, KeyFile) -> {ok, Handle} | {error, Reason} when
    Url :: binary(),
    Data :: map(),
    CertificateFile :: file:filename_all(),
    KeyFile :: file:filename_all(),
    Handle :: binary(),
    Reason :: term().
request(Url, Data, CertificateFile, KeyFile) ->
    Headers = [
        {"Authorization", "Handle clientCert=\"true\""}
    ],
    Request = {z_convert:to_list(Url), Headers, "application/json", jsx:encode(Data)},
    HttpOptions = [
        {ssl, ssl_options(CertificateFile, KeyFile)},
        {autoredirect, false},
        {relaxed, true},
        {timeout, ?HTTPC_TIMEOUT},
        {connect_timeout, ?HTTPC_TIMEOUT_CONNECT}
    ],
    Options = [
        {body_format, binary}
    ],
    case httpc:request(put, Request, HttpOptions, Options) of
        {ok, {{_, StatusCode, _}, _Headers, Body}} when StatusCode < 400 ->
            #{<<"handle">> := Handle} = jsx:decode(Body),
            {ok, Handle};
        {ok, {{_, StatusCode, _}, _Headers, Body}} ->
            lager:error(
                "ginger_handle_net: Error when registering handle ~p at ~s: ~p ~s",
                [Data, Url, StatusCode, Body]),
            {error, StatusCode};
        {error, Reason} ->
            lager:error(
                "ginger_handle_net: Error when registering handle ~p at ~s: ~p",
                [Data, Url, Reason]),
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


%% @doc Create HTTP request payload.
-spec data(#handle_net_handle{}, Prefix) -> Payload when
    Prefix :: binary(),
    Payload :: map().
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
