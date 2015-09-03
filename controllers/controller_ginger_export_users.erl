-module(controller_ginger_export_users).
-author("Driebit <tech@driebit.nl>").

%% API
-export([
    init/1,
    service_available/2,
    content_types_provided/2,
    charsets_provided/2,
    do_export/2
]).

-include_lib("include/controller_webmachine_helper.hrl").
-include_lib("include/zotonic.hrl").

init(DispatchArgs) -> {ok, DispatchArgs}.

service_available(ReqData, DispatchArgs) when is_list(DispatchArgs) ->
    Context  = z_context:new(ReqData, ?MODULE),
    z_context:lager_md(Context),
    Context1 = z_context:set(DispatchArgs, Context),
    ?WM_REPLY(true, Context1).

content_types_provided(ReqData, Context0) ->
    Context1 = ?WM_REQ(ReqData, Context0),
    Dispatch = z_context:get(zotonic_dispatch, Context1),
    case mod_ginger_export:get_content_type(Context1) of
        {ok, ContentType} ->
            Context2 = z_context:set(content_type_mime, ContentType, Context1),
            ?WM_REPLY([{ContentType, do_export}], Context2);
        {error, Reason} = Error ->
            lager:error("~p: mod_ginger_export error when fetching content type for ~p:~p: ~p",
                [z_context:site(Context1), Dispatch, Reason]),
            throw(Error)
    end.

charsets_provided(ReqData, Context) ->
    {[{"utf-8", fun(X) -> X end}], ReqData, Context}.

do_export(ReqData, Context0) ->
    Context1 = ?WM_REQ(ReqData, Context0),
    Query = [
        {cat, z_context:get_q(categories, Context1, [person])},
        {sort, id}
    ],
    Stream = {stream, {<<>>, fun() -> mod_ginger_export:do_data_export(Query, Context1) end}},
    Context2 = mod_ginger_export:set_filename(Context1),
    ?WM_REPLY(Stream, Context2).
