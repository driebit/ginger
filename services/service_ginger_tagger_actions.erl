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

    MediaId = process_file(Context),
    case z_context:get_q("rfids", Context) of
        undefined ->
            {error, missing_arg, "rfids"};
        Rfids ->
            case lookup_users(Rfids, Context) of
                [] ->
                    {error, syntax, "None of the RFIDs are known"};
                Users ->
                    case get_object(Context) of
                        undefined ->
                            {error, missing_arg, "object_id"};
                        ObjectId ->
                            Response = z_notifier:first(
                                #tagger_action{
                                    media = MediaId,
                                    rfids = z_context:get_q("rfids", Context),
                                    users = Users,
                                    object = ObjectId
                                },
                                Context
                            ),
                            ?DEBUG(Response),
                            z_convert:to_json(Response)
                    end
            end
    end.

get_object(Context) ->
    z_context:get_q("object_id", Context).

%% @doc Accept both multipart/form files and base64-encoded files.
-spec process_file(#context{}) -> undefined | integer().
process_file(Context) ->
    Upload = case z_context:get_q("file", Context) of
        undefined ->
            undefined;
        File = #upload{} ->
            %% multipart/form file
            File;
        Base64 ->
            %% Handle base64-encoded file
            FileContents = base64:decode(Base64),
            #upload{data=FileContents, filename="media"}
    end,

    case Upload of
        undefined ->
            undefined;
        Upload1->
            {ok, MediaId} = m_media:insert_file(Upload1, [], Context),
            MediaId
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
