%% @doc An RFID tag
-module(m_rfid).
-author("Driebit <tech@driebit.nl").

-export([
    get/2,
    add/3
]).

-include_lib("zotonic.hrl").

%% @doc Get RFID identity by number
-spec get(string(), #context{}) -> list() | undefined.
get(Rfid, Context) ->
    m_identity:lookup_by_type_and_key(rfid, normalise(Rfid), Context).

%% @doc Add RFID identity to a resource
-spec add(pos_integer() | atom(), binary(), #context{}) -> {error, string()} | {ok, pos_integer()}.
add(Resource, Rfid, Context) ->
    case m_rsc:rid(Resource, Context) of
        undefined ->
            {error, "Resource does not exist"};
        Id ->
            m_identity:insert_unique(Id, rfid, normalise(Rfid), Context)
    end.

%% @doc Normalise RFID number
-spec normalise(binary()) -> binary().
normalise(Rfid) ->
    z_string:to_lower(Rfid).
