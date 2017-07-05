%% @doc An RKD (Rijksbureau voor Kunsthistorische Documentatie) API client.
-module(m_rkd).

-include_lib("zotonic.hrl").

-behaviour(gen_model).

-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).

-define(RKD_ENDPOINT, <<"https://api.rkd.nl/api/">>).

m_find_value(record, #m{value = undefined} = M, _Context) ->
    M#m{value = record};
m_find_value(<<"https://rkd.nl/explore/artists/", Id/binary>>, #m{value = record}, _Context) ->
    case get_rkd(<<"record/artists/", Id/binary>>) of
        undefined ->
            undefined;
        #{<<"response">> := #{<<"docs">> := [Hd | _]}} ->
            Hd
    end;
m_find_value(_Key, #m{value = _UnsupportedUrl}, _Context) ->
    undefined.

m_to_list(_, _Context) ->
    [].

m_value(#m{}, _Context) ->
    undefined.


get_rkd(Path) ->
    ginger_http_client:get(<<?RKD_ENDPOINT/binary, Path/binary>>).
