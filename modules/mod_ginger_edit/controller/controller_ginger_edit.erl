-module(controller_ginger_edit).
-author("Loetie Kruger <loetie@driebit.nl>").

-export([
    resource_exists/2,
    previously_existed/2,
    moved_temporarily/2,
    is_authorized/2,
    html/1
]).

-include_lib("controller_html_helper.hrl").

%% @doc Check if the id in the request (or dispatch conf) exists.
resource_exists(ReqData, Context) ->
    Context1  = ?WM_REQ(ReqData, Context),
    ContextQs = z_context:ensure_qs(Context1),
    try
        Id = z_controller_helper:get_id(ContextQs),
        maybe_exists(Id, ContextQs)
    catch
        _:_ -> ?WM_REPLY(false, ContextQs)
    end.

%% @doc Check if the resource used to exist
previously_existed(ReqData, Context) ->
    controller_page:previously_existed(ReqData, Context).

moved_temporarily(ReqData, Context) ->
    controller_page:moved_temporarily(ReqData, Context).

%% @doc Check if the current user is allowed to view the resource.
is_authorized(ReqData, Context) ->
    controller_page:is_authorized(ReqData, Context).

%% @doc Show the page. Add a noindex header when requested by the editor.
html(Context) ->
    controller_page:html(Context).

maybe_exists(Id, Context) ->
    case {m_rsc:exists(Id, Context), z_context:get(cat, Context)} of
        {Exists, undefined} ->
            ?WM_REPLY(Exists, Context);
        {true, Cat} ->
            ?WM_REPLY(m_rsc:is_a(Id, Cat, Context), Context);
        {false, _} ->
            ?WM_REPLY(false, Context)
    end.

