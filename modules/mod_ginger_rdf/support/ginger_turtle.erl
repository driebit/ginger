-module(ginger_turtle).

-include("zotonic.hrl").
-include("../include/rdf.hrl").

-export([serialize/1]).

%% @doc Serialize a RDF resource to Turtle (https://www.w3.org/TR/turtle/)
-spec serialize(m_rdf:rdf_resource()) -> iodata().
serialize(#rdf_resource{triples = Triples}) ->
    [
     "@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns>.\n",
     "@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>.\n",
     "@prefix foaf: <http://xmlns.com/foaf/0.1/>.\n",
     "@prefix geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>.\n",
     "@prefix dcterms: <http://purl.org/dc/terms/>.\n",
     "@prefix dctype: <http://purl.org/dc/dcmitype/>.\n",
     "@prefix vcard: <http://www.w3.org/2006/vcard/ns#>.\n",
     "@prefix dbpedia-owl: <http://dbpedia.org/ontology/>.\n",
     "@prefix dbpedia: <http://dbpedia.org/property/>.\n",
     "@prefix schema: <http://schema.org/>.\n",
     "\n",
     [triple_to_turtle(T) || T <- Triples]
    ].

triple_to_turtle(#triple{subject = S, predicate = P, object = #rdf_resource{} = Rsc}) ->
    O = case Rsc#rdf_resource.id of
            undefined ->
                blank_node(Rsc);
            _ ->
                escape_uri(Rsc#rdf_resource.id)
        end,
    Ts = [triple_to_turtle(T#triple{subject = O}) || T <- Rsc#rdf_resource.triples],
    [to_line(subject(S), predicate(P), O), Ts];
triple_to_turtle(#triple{subject = undefined, predicate = P, object = O}) ->
    to_line(<<"[]">>, predicate(P), object(O));
triple_to_turtle(#triple{subject = S, predicate = P, object = O}) ->
    to_line(subject(S), predicate(P), object(O)).

to_line(S, P, O) ->
    [S, " ", P, " ", O, ".\n"].

subject(X) ->
    escape_uri(X).

predicate(X) ->
    escape_uri(X).

escape_uri(U = <<"http://", _/binary>>) ->
    [$<, U, $>];
escape_uri(U = <<"https://", _/binary>>) ->
    [$<, U, $>];
escape_uri(U) ->
    %% Prefixed URI or not an URI (i.e. blank node)
    U.

object(#rdf_value{value = undefined}) ->
    [$", $"];
object(#rdf_value{value = V}) ->
    [$", literal(V), $"];
object(O) ->
    escape_uri(O).

blank_node(Rsc) ->
    <<"_:", (erlang:integer_to_binary(erlang:phash2(Rsc)))/binary>>.

literal({{Y, Mo, D}, {H, Mn, S}})
  when is_integer(Y), is_integer(Mo), is_integer(D), is_integer(H), is_integer(Mn), is_integer(S) ->
    erlang:list_to_binary(
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
    try
        io_lib:format("~s", [V])
    catch
        _:_ -> io_lib:format("~p", [V])
    end.

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
escape(<<Char/utf8, Rest/binary>>) ->
    <<Char/utf8, (escape(Rest))/binary>>.
