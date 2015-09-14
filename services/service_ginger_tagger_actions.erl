-module(service_ginger_tagger_actions).
-author("Driebit <tech@driebit.nl>").

-svc_title("Register an action.").
-svc_description("Register an action, such as taking a picture, performed while scanning one or more RFIDS.").

-svc_needauth(true).

-export([
    process_post/2
]).

-include_lib("zotonic.hrl").
-include("../include/tagger.hrl").

process_post(_ReqData, Context) ->
    %% Look up configuration (not yet used)

    case process_file(Context) of
        {error, Message} ->
            {error, syntax, Message};
        {ok, MediaId} ->

            case z_context:get_q_all("rfids", Context) of
                [] ->
                    {error, missing_arg, "rfids"};
                undefined ->
                    {error, missing_arg, "rfids"};
                Rfids ->
                    case lookup_users(Rfids, Context) of
                        [] ->
                            lager:error(
                                "[~p] RFIDs ~p not known",
                                [z_context:site(Context), Rfids]
                            ),
                            {error, syntax, "None of the RFIDs are known"};
                        Users ->
                            case get_object(Context) of
                                undefined ->
                                    {error, missing_arg, "object_id"};
                                ObjectId ->
                                    lager:info(
                                        "[~p] received RFID action for RFIDs ~p (users ~p) with oject ~p",
                                        [z_context:site(Context), Rfids, Users, ObjectId]
                                    ),
                                    Response = z_notifier:first(
                                        #tagger_action{
                                            media = MediaId,
                                            rfids = Rfids,
                                            users = Users,
                                            object = ObjectId
                                        },
                                        Context
                                    ),
                                    ?DEBUG(Response),
                                    z_convert:to_json(Response)
                            end
                    end
            end
    end.

get_object(Context) ->
    z_convert:to_integer(z_context:get_q("object_id", Context)).

%% @doc Accept both multipart/form files and base64-encoded files.
-spec process_file(#context{}) -> undefined | integer().
process_file(Context) ->
    Upload = case z_context:get_q("attachment", Context) of
        undefined ->
            undefined;
        File = #upload{} ->
            %% multipart/form file
            File;
        Base64 ->
            %% Handle base64-encoded file
            try
                FileContents = base64:decode(Base64),
                #upload{data=FileContents, filename="media"}
            catch
                _Type:_Reason ->
                    %% Not a valid base64-encoded string
                    {error, "Attachment is not a valid base64-encoded string"}
            end
    end,

    case Upload of
        {error, _} ->
            Upload;
        undefined ->
            {ok, undefined};
        Upload1->
            m_media:insert_file(Upload1, [], Context)
    end.

%% @doc Look up users based on RFID
-spec lookup_users(list(), #context{}) -> list().
lookup_users(Rfids, Context) ->
    lists:foldl(
        fun(Rfid, Acc) ->
            case m_rfid:get(Rfid, Context) of
                undefined ->
                    Acc;
                Identity ->
                    [proplists:get_value(rsc_id, Identity)|Acc]
            end
        end,
        [],
        Rfids
    ).
