-module(mod_ginger_export).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger export module").
-mod_description("Export a list of resources to a csv file").
-mod_prio(500).
-mod_depends([mod_export]).

-export([
    observe_admin_menu/3,
    do_data_export/1,
    do_data_export/2,
    get_content_type/1,
    set_filename/1,
    observe_export_resource_header/2,
    observe_export_resource_encode/2
]).

-include_lib("include/zotonic.hrl").
-include_lib("modules/mod_admin/include/admin_menu.hrl").

observe_admin_menu(admin_menu, Acc, Context) ->
    case z_acl:is_allowed(use, mod_export, Context) of
        true ->
            [
                #menu_item{
                    id=ginger_export,
                    parent=admin_modules,
                    label=?__("Export to CSV", Context),
                    url={admin_ginger_export}
                }|
                Acc
            ];
        false ->
            Acc
    end.

do_data_export(Context) ->
    Query = [
        {cat_exclude, "person"},
        {cat_exclude, "artifact"},
        {cat_exclude, "media"},
        {cat_exclude, "meta"},
        {cat_exclude, "location"}
    ],
    do_data_export(Query, Context).

do_data_export(Query, Context) ->
    SearchResult = z_search:search({'query', Query}, {1, undefined}, Context),
    List = [ResultId || ResultId <- SearchResult#search_result.result],
    {<<>>, fun() -> do_body(List, Context) end }.

do_body(List0, Context) ->
    Data = lists:map(
        fun(Id) ->
            ResourceData = rsc_data(Id, m_rsc:is_a(Id, Context), Context),
            do_body_encode(ResourceData, Context)
        end,
        List0),
    DataBin = iolist_to_binary(Data),
    { DataBin, done }.

do_body_encode(Item, Context) ->
    ContentType = z_context:get(content_type_mime, Context),
    Id = proplists:get_value(id, Item),
    Dispatch = z_context:get(zotonic_dispatch, Context),
    case z_notifier:first(#export_resource_encode{
        id=Id,
        dispatch=Dispatch,
        content_type=ContentType,
        data=Item,
        state=undefined}, Context)
    of
        undefined -> <<>>;
        {ok, Enc} -> Enc
    end.

set_filename(Context) ->
    ContentType = z_context:get(content_type_mime, Context),
    Extension = case mimetypes:mime_to_exts(ContentType) of
                    undefined -> "bin";
                    Exts -> binary_to_list(hd(Exts))
                end,
    Filename = "export-"
        ++z_convert:to_list(z_dateformat:format("Y-m-d_His"))
        ++"."
        ++Extension,
    z_context:set_resp_header("Content-Disposition", "attachment; filename="++Filename, Context)
.

%% @doc Fetch the content type being served
get_content_type(Context) ->
    case z_context:get(content_type, Context) of
        csv ->
            {ok, "text/csv"};
        ContentType when is_list(ContentType) ->
            {ok, ContentType};
        undefined ->
            {error, no_content_type}
    end
.

rsc_data(Id, [person|_], Context) ->
    case m_identity:get_rsc(Id, username_pw, Context) of
        undefined ->
            %% ignore resource
            [];
        Identity ->
            [
                m_rsc:p(Id, id, Context),            %% id
                proplists:get_value(key, Identity),  %% username
                proplists:get_value(prop1, Identity) %% password
            ]
    end;
rsc_data(Id, _Cats, Context) ->
    [ z_html:unescape(
        z_html:strip(
            m_rsc:p(Id, Prop, Context)
        )
    ) || Prop <- rsc_fields() ].

%% field_labels() ->
%%     [
%%         "Titel",
%%         "Korte titel",
%%         "Samenvatting",
%%         "Tekst"
%%     ]
%% .

rsc_fields() ->
    [
        id,
        name,
        title,
        short_title,
        summary,
        body
    ].

-spec observe_export_resource_header(#export_resource_header{}, #context{}) -> tuple().
observe_export_resource_header(#export_resource_header{id = _Id}, _Context) ->
    {ok, ginger_export_rsc:get_headers()}.

-spec observe_export_resource_encode(#export_resource_encode{}, #context{}) -> {ok, list()}.
observe_export_resource_encode(#export_resource_encode{content_type = "text/csv", data = Id}, Context) when is_integer(Id) ->
    Data = ginger_export_rsc:export(Id, Context),
    {ok, export_encode_csv:encode(Data, Context)}.
