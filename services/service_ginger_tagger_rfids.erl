-module(service_ginger_tagger_rfids).
-author("Driebit <tech@driebit.nl>").

-svc_title("GET and POST RFIDs.").
-svc_needauth(true).

-export([
    process_get/2,
    process_post/2
]).

-include_lib("zotonic.hrl").

%% @doc Retrieve information about an RFID tag.
process_get(_ReqData, Context) ->
    case m_rfid:get(z_context:get_q("rfid", Context), Context) of
        undefined -> 
            {error, not_exists, "rfid"};
        RfidIdentity ->
            %% Retrieve all identities for user related to RfidIdentity
            UserId = proplists:get_value(rsc_id, RfidIdentity),
            
            %% Look up extra identities for this user
            Identities = lists:filtermap(
                fun(Type) ->
                    case m_identity:get_rsc(UserId, Type, Context) of
                        undefined -> false;
                        Identity ->
                            {true, {Type, proplists:get_value(key, Identity)}}        
                    end
                end,
                [facebook]
            ),
            
            z_convert:to_json(
                [
                    {user, m_rsc_export:full(UserId, Context)},
                    {identities, Identities}
                ]
            )
    end.

process_post(ReqData, Context) ->
    UserId = z_acl:user(Context),
    
    case ginger_json:decode(ReqData) of
        {error, Type, Argument} -> {error, Type, Argument};
        JsonBody ->
            Rfids = proplists:get_value(<<"rfids">>, JsonBody),
                    
            lists:foreach(
                fun(Rfid) ->
                    {ok, _IdentityId} = m_identity:insert_unique(UserId, rfid, Rfid, Context)
                end,
                Rfids
            ),
            
            %% Better to return a 201, for instance, but that's not possible with controller_api
            []
    end.
