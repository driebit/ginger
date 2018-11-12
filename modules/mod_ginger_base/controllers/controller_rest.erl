-module(controller_rest).

-export([
         init/1,
         allow_missing_post/2,
         malformed_request/2,
         allowed_methods/2,
         resource_exists/2,
         content_types_provided/2,
         to_json/2
        ]).

-include("controller_webmachine_helper.hrl").
-include("zotonic.hrl").
-include_lib("eunit/include/eunit.hrl").

%% NB: the Webmachine documenation uses "context" where we use "state",
%% we reserve "context" for the way it's used by Zotonic/Ginger.
-record(state, {mode, collection, path_info}).


%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init([Args]) ->
    Mode =  maps:get(mode, Args),
    Collection = maps:get(collection, Args, undefined),
    PathInfo = maps:get(path_info, Args, undefined),
    {ok, #state{mode = Mode, collection = Collection, path_info = PathInfo}}.

allow_missing_post(Req, State = #state{mode = collection, collection = edges}) ->
    {true, Req, State};
allow_missing_post(Req, State) ->
    {false, Req, State}.

malformed_request(Req, State = #state{mode = collection}) ->
    {false, Req, State};
malformed_request(Req, State = #state{mode = document, collection = resources, path_info = path}) ->
    {false, Req, State};
malformed_request(Req, State = #state{mode = document, collection = resources, path_info = id}) ->
    case string:to_integer(wrq:path_info(id, Req)) of
        {error, _Reason} ->
            {true, Req, State};
        {_Int, []} ->
            {false, Req, State};
        {_Int, _Rest} ->
            {true, Req, State}
    end.

allowed_methods(Req, State = #state{mode = collection, collection = edges}) ->
    {['POST', 'HEAD'], Req, State};
allowed_methods(Req, State) ->
    {['GET', 'HEAD'], Req, State}.

resource_exists(Req, State = #state{mode = collection}) ->
    {true, Req, State};
resource_exists(Req, State = #state{mode = document, collection = resources, path_info = id}) ->
    Context = z_context:new(Req, ?MODULE),
    Id = wrq:path_info(id, Req),
    {m_rsc:exists(Id, Context), Req, State};
resource_exists(Req, State = #state{mode = document, collection = resources, path_info = path}) ->
    Context = z_context:new(Req, ?MODULE),
    case path_to_id(wrq:path_info(path, Req), Context) of
        {ok, Id} ->
            {m_rsc:exists(Id, Context), Req, State};
        {error, _} ->
            {false, Req, State}
    end.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, State = #state{mode = collection, collection = resources}) ->
    Context = z_context:new(Req, ?MODULE),
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
to_json(Req, State = #state{mode = document, collection = resources, path_info = PathInfo}) ->
    Context = z_context:new(Req, ?MODULE),
    Id =
        case PathInfo of
            id ->
                erlang:list_to_integer(wrq:path_info(id, Req));
            path ->
                {ok, Result} = path_to_id(wrq:path_info(path, Req), Context),
                Result
        end,
    Json = jsx:encode(rsc(Id, Context, true)),
    {Json, Req, State}.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

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

%%%-----------------------------------------------------------------------------
%%% Tests
%%%-----------------------------------------------------------------------------

init_test_() ->
    { setup
      %% setup
    , fun () -> ok end
      %% cleanup
    , fun (_) -> ok end
      %% tests
    , [ fun () ->
                Map = #{mode => collection, collection => edges},
                {ok, State} = init([Map]),
                collection = State#state.mode,
                edges = State#state.collection,
                undefined = State#state.path_info
        end
      , fun () ->
                Map = #{mode => collection, collection => resources, path_info => id},
                {ok, State} = init([Map]),
                collection = State#state.mode,
                resources = State#state.collection,
                id = State#state.path_info
        end
      ]
    }.

allow_missing_post_test_() ->
    { setup
      %% setup
    , fun () -> ok end
      %% cleanup
    , fun (_) -> ok end
      %% tests
    , [ fun () ->
                {true, _, _ } =
                    allow_missing_post(req, #state{mode = collection, collection = edges}),
                {false, _, _ } =
                    allow_missing_post(req, #state{mode = collection, collection = resources}),
                {false, _, _ } =
                    allow_missing_post(req, #state{mode = document})
        end
      ]
    }.

allowed_methods_test_() ->
    { setup
      %% setup
    , fun () -> ok end
      %% cleanup
    , fun (_) -> ok end
      %% tests
    , [ fun () ->
                {Methods1, _, _ } =
                    allowed_methods(req, #state{mode = collection, collection = edges}),
                ?assert(lists:member('POST', Methods1)),
                ?assertNot(lists:member('GET', Methods1)),
                {Methods2, _, _ } =
                    allowed_methods(req, #state{mode = collection, collection = resources}),
                ?assertNot(lists:member('POST', Methods2)),
                {Methods3, _, _ } =
                    allowed_methods(req, #state{mode = document}),
                ?assertNot(lists:member('POST', Methods3))
        end
      ]
    }.

malformed_request_test_() ->
    { setup
      %% setup
    , fun () -> meck:new(wrq) end
      %% cleanup
    , fun (_) -> meck:unload(wrq) end
      %% tests
    , [ fun () ->
                {false, _, _} =
                    malformed_request(req, #state{mode = collection})
        end
      , fun () ->
                {false, _, _} =
                    malformed_request(req, #state{ mode = document
                                                 , collection = resources
                                                 , path_info = path
                                                 }
                                     )
        end
      , fun () ->
                meck:expect(wrq, path_info, 2, "not-an-integer"),
                {true, _, _} =
                    malformed_request(req, #state{ mode = document
                                                 , collection = resources
                                                 , path_info = id
                                                 }
                                     )
        end
      , fun () ->
                meck:expect(wrq, path_info, 2, "23"),
                {false, _, _} =
                    malformed_request(req, #state{ mode = document
                                                 , collection = resources
                                                 , path_info = id
                                                 }
                                     )
        end
      ]
    }.

resource_exists_test_() ->
    { setup
      %% setup
    , fun () ->
              meck:new(z_context),
              meck:new(wrq),
              meck:new(m_rsc),
              ok
      end
      %% cleanup
    , fun (_) ->
              meck:unload(m_rsc),
              meck:unload(wrq),
              meck:unload(z_context),
              ok
      end
      %% tests
    , [ fun () ->
                State = #state{mode = collection, collection = resources},
                {true, _, _} = resource_exists(req, State)
        end
      , fun () ->
                meck:expect(z_context, new, 2, ok),
                meck:expect(wrq, path_info, 2, "1"),
                State = #state{ mode = document
                              , collection = resources
                              , path_info = id
                              },
                meck:expect(m_rsc, exists, 2, false),
                {false, _, _} = resource_exists(req, State),
                meck:expect(m_rsc, exists, 2, true),
                {true, _, _} = resource_exists(req, State)
        end
      , fun () ->
                meck:expect(z_context, new, 2, ok),
                State = #state{ mode = document
                              , collection = resources
                              , path_info = path
                              },
                meck:expect(wrq, path_info, 2, "/"),
                meck:expect(m_rsc, name_to_id, 2, {ok, 1}),
                meck:expect(m_rsc, exists, 2, true),
                {true, _, _} = resource_exists(req, State),
                meck:expect(m_rsc, exists, 2, false),
                {false, _, _} = resource_exists(req, State),
                meck:expect(m_rsc, name_to_id, 2, {error, whatever}),
                {false, _, _} = resource_exists(req, State)
        end
      ]
    }.
