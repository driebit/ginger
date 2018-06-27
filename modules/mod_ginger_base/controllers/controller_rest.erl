-module(controller_rest).

-export([
         init/1,
         malformed_request/2,
         resource_exists/2,
         content_types_provided/2,
         to_json/2
        ]).

-include("controller_webmachine_helper.hrl").
-include("zotonic.hrl").

%% NB: the Webmachine documenation uses "context" where we use "state",
%% we reserve "context" for the way it's used by Zotonic/Ginger.
-record(state, {mode, path_info}).


%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init(Args) ->
    Mode =  proplists:get_value(mode, Args),
    PathInfo = proplists:get_value(path_info, Args),
    {ok, #state{mode = Mode, path_info = PathInfo}}.

malformed_request(Req, State = #state{mode = collection}) ->
    {false, Req, State};
malformed_request(Req, State = #state{mode = document, path_info = path}) ->
    {false, Req, State};
malformed_request(Req, State = #state{mode = document, path_info = id}) ->
    case string:to_integer(wrq:path_info(id, Req)) of
        {error, _Reason} ->
            {true, Req, State};
        {_Int, []} ->
            {false, Req, State};
        {_Int, _Rest} ->
            {true, Req, State}
    end.

resource_exists(Req, State = #state{mode = collection}) ->
    {true, Req, State};
resource_exists(Req, State = #state{mode = document, path_info = id}) ->
    Context = z_context:new(Req, ?MODULE),
    Id = wrq:path_info(id, Req),
    {m_rsc:exists(Id, Context), Req, State};
resource_exists(Req, State = #state{mode = document, path_info = path}) ->
    Context = z_context:new(Req, ?MODULE),
    case path_to_id(wrq:path_info(path, Req), Context) of
        {ok, Id} ->
            {m_rsc:exists(Id, Context), Req, State};
        {error, _} ->
            {false, Req, State}
    end.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, State = #state{mode = collection}) ->
    Context = z_context:new(Req, ?MODULE),
    Args1 = search_query:parse_request_args(
              proplists_filter(
                fun (Key) -> lists:member(Key, ["cat", "hasobject", "hassubject"]) end,
                wrq:req_qs(Req)
               )
             ),
    Args2 = ginger_search:query_arguments(
              [{cat_exclude_defaults, false}, {filter, ["is_published", true]}],
              Context
             ),
    Ids = z_search:query_(Args1 ++ Args2, Context),
    Json = jsx:encode([rsc(Id, Context, true) || Id <- Ids]),
    {Json, Req, State};
to_json(Req, State = #state{mode = document, path_info = PathInfo}) ->
    Context = z_context:new(Req, ?MODULE),
    Id = erlang:list_to_integer(
           case PathInfo of
               id ->
                   wrq:path_info(id, Req);
               path ->
                   {ok, Result} = path_to_id(wrq:path_info(path, Req), Context),
                   Result
           end
          ),
    Json = jsx:encode(rsc(Id, Context, true)),
    {Json, Req, State}.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

rsc(Id, Context, true) ->
    edges(rsc(Id, Context, false), Context);
rsc(Id, Context, IncludeEdges) ->
    Map = #{
            id => Id,
            title => translation(Id, title, Context),
            body => translation(Id, body, Context),
            summary => translation(Id, summary, Context),
            path => m_rsc:page_url(Id, Context),
            publication_date => m_rsc:p(Id, publication_start, Context),
            category => proplists:get_value(is_a, m_rsc:p(Id, category, Context)),
            properties => custom_props(Id, Context)
           },
    case IncludeEdges of
        false ->
            Map;
        true ->
            Map#{edges => edges(Id, Context)}
    end.

edges(RscId, Context) ->
    [rsc(Id, Context, false) || Id <- m_edge:objects(RscId, Context)].

custom_props(Id, Context) ->
    case m_site:get(types, Context) of
        undefined ->
            null;
        CustomProps ->
            maps:map(
               fun (PropName, TypeModule) ->
                       TypeModule:encode(m_rsc:p(Id, PropName, Context))
               end,
               CustomProps
            )
    end.

translation(Id, Prop, Context) ->
    DefaultLanguage = z_trans:default_language(Context),
    case m_rsc:p(Id, Prop, <<>>, Context) of
        {trans, Translations} ->
            [{Key, z_html:unescape(Value)} || {Key, Value} <- Translations];
        Value ->
            [{DefaultLanguage, Value}]
    end.

proplists_filter(Filter, List) ->
    lists:foldr(
      fun (Key, Acc) ->
              case Filter(Key) of
                  true ->
                      Acc;
                  false ->
                      proplists:delete(Key, Acc)
              end
      end,
      List,
      proplists:get_keys(List)
     ).

path_to_id("/", Context) ->
    m_rsc:name_to_id("home", Context);
path_to_id(Path, Context) ->
    case string:tokens(Path, "/") of
        ["page", Id | _] ->
            {ok, Id};
        [_Language, "page", Id | _] ->
            {ok, Id};
        _ ->
            case m_rsc:page_path_to_id(Path, Context) of
                {redirect, Id} ->
                    {ok, Id};
                Result ->
                    Result
            end
    end.
