%% @doc An RFID tag
-module(m_rfid).
-author("Driebit <tech@driebit.nl").

-export([
    get/2,
    add/3,
    delete/3,
    convert_endian/1
]).

-include_lib("zotonic.hrl").

%% @doc Get RFID identity by number
-spec get(binary(), #context{}) -> list(tuple()) | undefined.
get(Rfid, Context) ->
    case m_identity:lookup_by_type_and_key(rfid, normalise(Rfid), Context) of
        undefined ->
            %% Fall back to other endianness
            m_identity:lookup_by_type_and_key(rfid, convert_endian(normalise(Rfid)), Context);
        Identity ->
            Identity
    end.

%% @doc Add RFID identity to a resource
-spec add(m_rsc:resource(), binary(), #context{}) -> {error, string()} | {ok, pos_integer()}.
add(Resource, Rfid, Context) ->
    case m_rsc:rid(Resource, Context) of
        undefined ->
            {error, "Resource does not exist"};
        Id ->
            m_identity:insert_unique(Id, rfid, normalise(Rfid), Context)
    end.

%% @doc Delete an RFID
-spec delete(m_rsc:resource(), binary(), #context{}) -> ok.
delete(Resource, Rfid, Context) ->
    m_identity:delete_by_type_and_key(Resource, rfid, normalise(Rfid), Context),

    %% Can be removed when https://github.com/zotonic/zotonic/pull/1376 is merged
    z_mqtt:publish(["~site", "rsc", Resource, "identity"], {identity, rfid}, Context).

%% @doc Normalise RFID number
-spec normalise(binary()) -> binary().
normalise(Rfid) ->
    z_string:to_lower(Rfid).

%% @doc Convert between little-endian and big-endian (9C9C25C5 <-> C5259C9C).
%%      This is a fallback for RFID chips that were encoded in little instead of
%%      big endian.
-spec convert_endian(binary()) -> binary().
convert_endian(HexadecimalRfid) when size(HexadecimalRfid) rem 2 =:= 0 ->
    convert_endian(HexadecimalRfid, <<>>);
convert_endian(HexadecimalRfid) ->
    HexadecimalRfid.

convert_endian(<<>>, Acc) ->
    Acc;
convert_endian(<<Head:2/binary, Tail/binary>>, Acc) ->
    convert_endian(Tail, <<Head/binary, Acc/binary>>).
