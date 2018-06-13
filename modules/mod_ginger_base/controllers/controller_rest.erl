-module(controller_rest).

-export([
         init/1,
         resource_exists/2,
         content_types_provided/2,
         to_json/2
        ]).

-include("controller_webmachine_helper.hrl").
-include("zotonic.hrl").

%% NB: the Webmachine documenation uses "context" where we use "state",
%% we reserve "context" for the way it's used by Zotonic/Ginger.
-record(state, {mode}).


%%%-----------------------------------------------------------------------------
%%% Resource functions
%%%-----------------------------------------------------------------------------

init(Args) ->
    Mode = proplists:get_value(mode, Args),
    {ok, #state{mode = Mode}}.

resource_exists(Req, State = #state{mode = collection}) ->
    {true, Req, State};
resource_exists(Req, State = #state{mode = document}) ->
    Id = wrq:path_info(id, Req),
    Context = z_context:new(Req, ?MODULE),
    Exists = m_rsc:exists(Id, Context),
    {Exists, Req, State};
resource_exists(Req, State) ->
    {false, Req, State}.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

to_json(Req, State = #state{mode = collection}) ->
    Context = z_context:new(Req, ?MODULE),
    Qs = proplists_keep(["cat", "hasobject", "hassubject"], wrq:req_qs(Req)),
    Args1 = ?DEBUG(search_query:parse_request_args(Qs)),
    Args2 = ginger_search:query_arguments(
              [{cat_exclude_defaults, false}, {filter, ["is_published", true]}],
              Context),
    Ids = z_search:query_(Args1 ++ Args2, Context),
    Json = jsx:encode([get_rsc(Id, Context) || Id <- Ids]),
    {Json, Req, State};
to_json(Req, State = #state{mode = document}) ->
    Id = wrq:path_info(id, Req),
    Context = z_context:new(Req, ?MODULE),
    Json = jsx:encode(get_rsc(Id, Context)),
    {Json, Req, State}.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------

get_rsc(Id, Context) ->
    DefaultLanguage = z_trans:default_language(Context),
    #{
      id => Id,
      title => translation(Id, title, DefaultLanguage, Context),
      body => translation(Id, body, DefaultLanguage, Context),
      summary => translation(Id, summary, DefaultLanguage, Context),
      path => m_rsc:page_url(Id, Context),
      publication_date => m_rsc:p(Id, publication_start, Context),
      category => proplists:get_value(is_a, m_rsc:p(Id, category, Context))
     }.

translation(Id, Prop, DefaultLanguage, Context) ->
    case m_rsc:p(Id, Prop, <<>>, Context) of
        {trans, Translations} ->
            [{Key, z_html:unescape(Value)} || {Key, Value} <- Translations];
        Value ->
            [{DefaultLanguage, Value}]
    end.

proplists_keep(Keys, List) ->
    lists:foldr(
      fun (Key, Acc) ->
              case lists:member(Key, Keys) of
                  true ->
                      Acc;
                  false ->
                      proplists:delete(Key, Acc)
              end
      end,
      List,
      proplists:get_keys(List)
     ).
