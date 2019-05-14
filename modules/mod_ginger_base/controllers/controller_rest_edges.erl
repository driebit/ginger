-module(controller_rest_edges).

-export([ init/1
        , is_authorized/2
        , service_available/2
        , allowed_methods/2
        , resource_exists/2
        , delete_resource/2
        , process_post/2
        ]
       ).

-include("controller_webmachine_helper.hrl").
-include("zotonic.hrl").
-include_lib("eunit/include/eunit.hrl").

%% NB: the Webmachine documenation uses "context" where we use "state",
%% we reserve "context" for the way it's used by Zotonic/Ginger.
-record(state, { mode = undefined
               , context = undefined
               }
       ).

%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init(Args) ->
    Mode = proplists:get_value(mode, Args),
    {ok, #state{mode = Mode}}.

service_available(Req, State) ->
    Context = z_context:continue_session(z_context:new(Req, ?MODULE)),
    {true, Req, State#state{context = Context}}.

is_authorized(Req, State) ->
    %% Auth checks are only necessary for these methods.
    case lists:member(wrq:method(Req), ['POST', 'DELETE']) of
        false ->
            {true, Req, State};
        true ->
            Context = State#state.context,
            case z_acl:user(Context) of
                undefined ->
                    %% Return a 403 instead of a 401 as we don't use HTTP authentication
                    {{halt, 403}, Req, Context};
                _Id ->
                    {true, Req, State}
            end
    end.

allowed_methods(Req, State = #state{mode = document}) ->
    {['DELETE', 'HEAD'], Req, State};
allowed_methods(Req, State = #state{mode = collection}) ->
    {['POST', 'HEAD'], Req, State}.

resource_exists(Req, State = #state{mode = collection}) ->
    {true, Req, State};
resource_exists(Req, State = #state{mode = document}) ->
    Context = State#state.context,
    Subject = integer_path_info(subject, Req),
    Predicate = predicate_id_from_path(Req, Context),
    Object = integer_path_info(object, Req),
    Result = undefined /= m_edge:get_id(Subject, Predicate, Object, Context),
    {Result, Req, State}.

delete_resource(Req, State = #state{mode = document}) ->
    Context = State#state.context,
    Subject = integer_path_info(subject, Req),
    Predicate = predicate_id_from_path(Req, Context),
    Object = integer_path_info(object, Req),
    ok = m_edge:delete(Subject, Predicate, Object, Context),
    {true, Req, State}.

process_post(Req, State = #state{mode = collection}) ->
    Context = State#state.context,
    Subject = integer_path_info(id, Req),
    Predicate = predicate_id_from_path(Req, Context),
    {Body, Req1} = wrq:req_body(Req),
    Data = jsx:decode(Body, [return_maps, {labels, atom}]),
    Object = maps:get(object, Data),
    case m_edge:insert(Subject, Predicate, Object, Context) of
        {ok, _EdgeId} ->
            {true, Req1, State};
        {error, _Reason} ->
            {false, Req1, State}
    end.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

integer_path_info(Binding, Req) ->
    erlang:list_to_integer(wrq:path_info(Binding, Req)).

predicate_id_from_path(Req, Context) ->
    Name = wrq:path_info(predicate, Req),
    {ok, Id} = m_rsc:name_to_id(Name, Context),
    Id.

%%%-----------------------------------------------------------------------------
%%% Tests
%%%-----------------------------------------------------------------------------

init_test_() ->
    [ fun () ->
              Map = [{mode, collection}],
              {ok, State} = init(Map),
              collection = State#state.mode,
              ok
      end
    ].

allowed_methods_test_() ->
    [ fun () ->
              {Methods, _, _ } =
                  allowed_methods(req, #state{mode = collection}),
              ?assert(lists:member('POST', Methods)),
              ?assert(lists:member('HEAD', Methods)),
              ?assertEqual(2, erlang:length(Methods)),
              ok
      end
    , fun () ->
              {Methods, _, _ } =
                  allowed_methods(req, #state{mode = document}),
              ?assert(lists:member('DELETE', Methods)),
              ?assert(lists:member('HEAD', Methods)),
              ?assertEqual(2, erlang:length(Methods)),
              ok
      end
    ].

resource_exists_test_() ->
    {Setup, Cleanup} = controller_rest:setup_cleanup([z_context, wrq, m_rsc, m_edge]),
    { setup, Setup, Cleanup
      %% tests
    , [ fun () ->
                State = #state{mode = collection},
                {true, _, _} = resource_exists(req, State),
                ok
        end,
        fun () ->
                State = #state{mode = document},
                controller_rest:meck_map_lookup(
                  wrq, path_info,
                  #{ subject => "1"
                   , object => "2"
                   , predicate => "depiction"
                   }
                 ),
                meck:expect(m_rsc, name_to_id, 2, {ok, 3}),
                meck:expect(m_edge, get_id, 4, undefined),
                {false, _, _} = resource_exists(req, State),
                meck:expect(m_edge, get_id, 4, 3),
                {true, _, _} = resource_exists(req, State),
                ok
        end
      ]
    }.

process_post_test_() ->
    {Setup, Cleanup} = controller_rest:setup_cleanup([wrq, m_rsc, m_edge]),
    { setup, Setup, Cleanup
      %% tests
    , [ fun () ->
                State = #state{ mode = collection
                              , context = context
                              },
                controller_rest:meck_map_lookup(
                  wrq, path_info,
                  #{ id => "1"
                   , predicate => "depiction"
                   }
                 ),
                Body = jsx:encode(#{object => 2}),
                meck:expect(wrq, req_body, 1, {Body, req}),
                PredicateId = 3,
                meck:expect(m_rsc, name_to_id, 2, {ok, PredicateId}),
                EdgeId = 4,
                meck:expect(m_edge, insert, 4, {ok, EdgeId}),
                {true, _, _} = process_post(req, State),
                meck:expect(m_edge, insert, 4, {error, {acl, false}}),
                {false, _, _} = process_post(req, State),
                ok
        end
      ]
    }.
