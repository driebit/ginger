-module(ginger_turtle).

-include("zotonic.hrl").
-include("../include/rdf.hrl").

-export([serialize/1, escape/1, escape_char/1]).

%% @doc Serialize a RDF resource to Turtle (https://www.w3.org/TR/turtle/)
-spec serialize(m_rdf:rdf_resource()) -> iodata().
serialize(#rdf_resource{triples = Triples}) ->
    [triple_to_turtle(T) || T <- Triples].

triple_to_turtle(#triple{subject = S, predicate = P, object = #rdf_resource{} = Rsc}) ->
    O = blank_node(Rsc),
    Ts = [triple_to_turtle(T#triple{subject = O}) || T <- Rsc#rdf_resource.triples],
    [to_line(subject(S), predicate(P), O), Ts];
triple_to_turtle(#triple{subject = undefined, predicate = P, object = O}) ->
    to_line(<<"[]">>, predicate(P), object(O));
triple_to_turtle(#triple{subject = S, predicate = P, object = O}) ->
    to_line(subject(S), predicate(P), object(O)).

to_line(S, P, O) ->
    [S, " ", P, " ", O, ".\n"].

subject(X) ->
    uri_or_blank_node(X).

predicate(X) ->
    uri_or_blank_node(X).

uri_or_blank_node(U = <<"http://", _/binary>>) ->
    [$<, U, $>];
uri_or_blank_node(U = <<"https://", _/binary>>) ->
    [$<, U, $>];
uri_or_blank_node(U) ->
    %% Prefixed URI or blank node
    U.

object(#rdf_value{value = undefined}) ->
    [$", $"];
object(#rdf_value{value = V}) ->
    [$", literal(V), $"];
object(O) ->
    uri_or_blank_node(O).

blank_node(Rsc) ->
    <<"_:", (erlang:integer_to_binary(erlang:phash2(Rsc)))/binary>>.

literal({{Y, Mo, D}, {H, Mn, S}}) ->
    erlang:list_to_binary(
      %% zotonic: z_datetime:format/?
      io_lib:format(
        "~4.10.0B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0BZ",
        [Y, Mo, D, H, Mn, S]
       )
     );
literal(V) when is_binary(V) ->
    escape(V);
literal(V) when is_list(V) ->
    escape(erlang:list_to_binary(V));
literal(V) ->
    V.

escape(<<>>) ->
    <<>>;
escape(<<$\b, Rest/binary>>) ->
    <<$\\, $b, (escape(Rest))/binary>>;
escape(<<$\t, Rest/binary>>) ->
    <<$\\, $t, (escape(Rest))/binary>>;
escape(<<$\n, Rest/binary>>) ->
    <<$\\, $n, (escape(Rest))/binary>>;
escape(<<$\f, Rest/binary>>) ->
    <<$\\, $f, (escape(Rest))/binary>>;
escape(<<$\r, Rest/binary>>) ->
    <<$\\, $r, (escape(Rest))/binary>>;
escape(<<$", Rest/binary>>) ->
    <<$\\, $", (escape(Rest))/binary>>;
escape(<<$', Rest/binary>>) ->
    <<$\\, $', (escape(Rest))/binary>>;
escape(<<$\\, Rest/binary>>) ->
    <<$\\, $\\, (escape(Rest))/binary>>;
escape(<<C/utf8, Cs/binary>>) ->
    <<C/utf8, (escape(Cs))/binary>>.
