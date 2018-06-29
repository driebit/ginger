-module(ginger_turtle).

-include("zotonic.hrl").
-include("../include/rdf.hrl").

-export([serialize/1]).

%% @doc Serialize a RDF resource to Turtle
-spec serialize(m_rdf:rdf_resource()) -> iodata().
serialize(#rdf_resource{triples = Triples}) ->
    [triple_to_turtle(T) || T <- Triples].

-spec triple_to_turtle(#triple{}) -> binary().
triple_to_turtle(#triple{subject = S, predicate = P, object = O}) ->
    Object = case O of
                 #rdf_value{value = V} ->
                     quotes(V);
                 _ ->
                     uri(O)
             end,
    <<
      (uri(S))/binary,
      (space())/binary,
      (uri(P))/binary,
      (space())/binary,
      Object/binary,
      (full_stop())/binary,
      (new_line())/binary
    >>.

-spec uri(binary()) -> binary().
uri(U = <<"http://", _/binary>>) ->
    brackets(U);
uri(U = <<"https://", _/binary>>) ->
    brackets(U);
uri(U) ->
    U.

-spec brackets(binary()) -> binary().
brackets(B) ->
    <<"<", B/binary, ">">>.

-spec quotes(binary()) -> binary().
quotes(B) ->
    <<"\"", B/binary, "\"">>.

-spec space() -> binary().
space() ->
    <<" ">>.

-spec full_stop() -> binary().
full_stop() ->
    <<".">>.

-spec new_line() -> binary().
new_line() ->
   <<"\n">>.
