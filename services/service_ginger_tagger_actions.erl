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
    case m_rsc:name_to_id_cat(
        z_context:get_q("configuration", Context),
        rfid_device,
        Context
    ) of 
        {error, _} ->
            {error, not_exists, z_context:get_q("configuration", Context)};
        {ok, Configuration} ->
            #rsc_list{list=Locations} = m_rsc:o(Configuration, located_at, Context),
            
            %% Accept both multipart/form files and base64-encoded files.
            Upload = case z_context:get_q("file", Context) of
                File = #upload{} -> 
                    %% multipart/form file
                    File;
                Base64 -> 
                    %% Handle base64-encoded file
                    FileContents = base64:decode(Base64),
                    #upload{data=FileContents, filename="media"}
            end,
            
            {ok, MediaId} = m_media:insert_file(Upload, [], Context),                    

            %% For now, just use the first (and probably only) location
            Location = hd(Locations),
            z_notifier:notify(
                #tagger_action{
                    action=m_rsc:p(Configuration, action, Context),
                    location=Location,
                    media=MediaId,
                    rfids=z_context:get_q("rfids", Context)
                },
                Context
            ),
            ok
    end.
