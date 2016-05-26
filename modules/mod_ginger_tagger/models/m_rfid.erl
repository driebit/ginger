%% @doc An RFID tag
-module(m_rfid).
-author("Driebit <tech@driebit.nl").

-export([
    get/2
]).

-include_lib("zotonic.hrl").

%% @doc Get RFID identity
-spec get(string(), #context{}) -> list() | undefined.
get(Rfid, Context) ->
    m_identity:lookup_by_type_and_key(rfid, Rfid, Context).
