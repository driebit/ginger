-module(controller_rest_resources).

-export([ init/1
        , service_available/2
        , malformed_request/2
        , allowed_methods/2
        , resource_exists/2
        , content_types_provided/2
        , to_json/2
        , process_post/2
        ]
       ).

-include("controller_webmachine_helper.hrl").
-include("zotonic.hrl").
-include_lib("eunit/include/eunit.hrl").

%% NB: the Webmachine documenation uses "context" where we use "state",
%% we reserve "context" for the way it's used by Zotonic/Ginger.
-record(state, { mode = undefined
               , path_info = undefined
               , context = undefined
               }
       ).

%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init([Args]) ->
    Mode =  maps:get(mode, Args),
    PathInfo = maps:get(path_info, Args, undefined),
    {ok, #state{mode = Mode, path_info = PathInfo}}.

service_available(Req, State) ->
    Context = z_context:continue_session(z_context:new(Req, ?MODULE)),
    {true, Req, State#state{context = Context}}.

malformed_request(Req, State = #state{mode = document, path_info = id}) ->
    case string:to_integer(wrq:path_info(id, Req)) of
        {error, _Reason} ->
            {true, Req, State};
        {_Int, []} ->
            {false, Req, State};
        {_Int, _Rest} ->
            {true, Req, State}
    end;
malformed_request(Req, State) ->
    {false, Req, State}.

allowed_methods(Req, State) ->
    {['GET', 'POST', 'HEAD'], Req, State}.

resource_exists(Req, State = #state{mode = collection}) ->
    {true, Req, State};
resource_exists(Req, State = #state{mode = document, path_info = id}) ->
    Context = State#state.context,
    Id = wrq:path_info(id, Req),
    {m_rsc:exists(Id, Context), Req, State};
resource_exists(Req, State = #state{mode = document, path_info = path}) ->
    Context = State#state.context,
    case path_to_id(wrq:path_info(path, Req), Context) of
        {ok, Id} ->
            {m_rsc:exists(Id, Context), Req, State};
        {error, _} ->
            {false, Req, State}
    end.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, State = #state{mode = collection}) ->
    Context = State#state.context,
    Args1 = search_query:parse_request_args(
              proplists_filter(
                fun (Key) -> lists:member(Key, supported_search_args()) end,
                wrq:req_qs(Req)
               )
             ),
    Args2 = ginger_search:query_arguments(
              [{cat_exclude_defaults, true}, {filter, ["is_published", true]}],
              Context
             ),
    Ids = z_search:query_(Args1 ++ Args2, Context),
    Json = jsx:encode([rsc(Id, Context, true) || Id <- Ids]),
    {Json, Req, State};
to_json(Req, State = #state{mode = document, path_info = PathInfo}) ->
    Context = State#state.context,
    Id =
        case PathInfo of
            id ->
                integer_path_info(id, Req);
            path ->
                {ok, Result} = path_to_id(wrq:path_info(path, Req), Context),
                Result
        end,
    Json = jsx:encode(rsc(Id, Context, true)),
    {Json, Req, State}.

process_post(Req, State = #state{mode = collection}) ->
    Context = State#state.context,
    {Body, Req1} = wrq:req_body(Req),
    Data = jsx:decode(Body, [return_maps, {labels, atom}]),
    lager:debug("Data = ~p", [Data]),
    Props = lists:foldl( fun post_props/2
                       , []
                       , maps:to_list(Data)
                       ),
    {ok, Id} = m_rsc:insert(Props, Context),
    Location = "/data/resources/" ++ erlang:integer_to_list(Id),
    Req2 = wrq:set_resp_headers([{"Location", Location}], Req1),
    {{halt, 201}, Req2, State}.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

post_props(Trans = {body, _}, Acc) ->
    trans(Trans, Acc);
post_props({category, Value}, Acc) ->
    [{category, Value} | Acc];
post_props({edges, _}, Acc) ->
    Acc;
post_props({is_published, Value}, Acc) ->
    [{is_published, Value} | Acc];
post_props({path, Value}, Acc) ->
    [{path, Value} | Acc].
post_props({properties, Value}, Acc) ->
    maps:to_list(Value) ++ Acc;
post_props(Trans = {summary, _}, Acc) ->
    trans(Trans, Acc);
post_props(Trans = {title, _}, Acc) ->
    trans(Trans, Acc).

trans({Key, Value}, Acc) ->
    [{Key, {trans, maps:to_list(Value)}} | Acc].

supported_search_args() ->
    ["cat", "hasobject", "hassubject", "sort"].

rsc(Id, Context, IncludeEdges) ->
    Map = m_ginger_rest:rsc(Id, Context),
    case IncludeEdges of
        false ->
            Map;
        true ->
            m_ginger_rest:with_edges(Map, Context)
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
            {ok, erlang:list_to_integer(Id)};
        [_Language, "page", Id | _] ->
            {ok, erlang:list_to_integer(Id)};
        _ ->
            case m_rsc:page_path_to_id(Path, Context) of
                {redirect, Id} ->
                    {ok, Id};
                Result ->
                    Result
            end
    end.

integer_path_info(Binding, Req) ->
    erlang:list_to_integer(wrq:path_info(Binding, Req)).

%%%-----------------------------------------------------------------------------
%%% Tests
%%%-----------------------------------------------------------------------------

init_test_() ->
    [ fun () ->
              Map = #{mode => collection, path_info => id},
              {ok, State} = init([Map]),
              collection = State#state.mode,
              id = State#state.path_info,
              ok
      end
    ].

allowed_methods_test_() ->
    [ fun () ->
              {Methods, _, _} = allowed_methods(req, state),
              ?assert(lists:member('GET', Methods)),
              ?assert(lists:member('POST', Methods)),
              ?assert(lists:member('HEAD', Methods)),
              ?assertEqual(3, erlang:length(Methods)),
              ok
      end
    ].

malformed_request_test_() ->
    {Setup, Cleanup} = controller_rest:setup_cleanup([wrq]),
    { setup, Setup, Cleanup
      %% tests
    , [ fun () ->
                {false, _, _} =
                    malformed_request(req, #state{mode = collection}),
                ok
        end
      , fun () ->
                {false, _, _} =
                    malformed_request(req, #state{ mode = document
                                                 , path_info = path
                                                 }
                                     ),
                ok
        end
      , fun () ->
                meck:expect(wrq, path_info, 2, "not-an-integer"),
                {true, _, _} =
                    malformed_request(req, #state{ mode = document
                                                 , path_info = id
                                                 }
                                     ),
                ok
        end
      , fun () ->
                meck:expect(wrq, path_info, 2, "23"),
                {false, _, _} =
                    malformed_request(req, #state{ mode = document
                                                 , path_info = id
                                                 }
                                     ),
                ok
        end
      ]
    }.

resource_exists_test_() ->
    {Setup, Cleanup} = controller_rest:setup_cleanup([z_context, wrq, m_rsc, m_edge]),
    { setup, Setup, Cleanup
      %% tests
    , [ fun () ->
                State = #state{mode = collection},
                {true, _, _} = resource_exists(req, State),
                ok
        end
      , fun () ->
                State = #state{mode = document, path_info = id},
                meck:expect(z_context, new, 2, ok),
                meck:expect(wrq, path_info, 2, "1"),
                meck:expect(m_rsc, exists, 2, false),
                {false, _, _} = resource_exists(req, State),
                meck:expect(m_rsc, exists, 2, true),
                {true, _, _} = resource_exists(req, State),
                ok
        end
      , fun () ->
                State = #state{mode = document, path_info = path},
                meck:expect(z_context, new, 2, ok),
                meck:expect(wrq, path_info, 2, "/"),
                meck:expect(m_rsc, name_to_id, 2, {ok, 1}),
                meck:expect(m_rsc, exists, 2, true),
                {true, _, _} = resource_exists(req, State),
                meck:expect(m_rsc, exists, 2, false),
                {false, _, _} = resource_exists(req, State),
                meck:expect(m_rsc, name_to_id, 2, {error, whatever}),
                {false, _, _} = resource_exists(req, State),
                ok
        end
      ]
    }.
