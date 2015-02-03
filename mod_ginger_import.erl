%% @author Driebit <info@driebit.nl>
%% @copyright 2014-2015 driebit b.v.

-module(mod_ginger_import).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger import").
-mod_description("Provides import of CSV files").
-mod_prio(200).

-export([
    observe_import_csv_definition/2
    ]).

-include_lib("zotonic.hrl").
-include_lib("modules/mod_import_csv/include/import_csv.hrl").

%% @doc Recognize the edge import file
observe_import_csv_definition(#import_csv_definition{basename="edges.csv", filename=Filename}, Context) ->
    case mod_import_csv:inspect_file(Filename) of
        {ok, #filedef{columns=["subject", "predicate", "object" | _]} = FD} ->
            import_edges(FD, Context),
            ok;
        {error, _} ->
            undefined
    end;
observe_import_csv_definition(_, _Context) ->
    undefined.

import_edges(Def, Context) ->
    lager:info("[~p] Ginger import: start importing edges", [z_context:site(Context)]),
    erlang:spawn(fun() ->
                    do_import_edges(Def, Context)
                 end).

do_import_edges(Def, Context) ->
    {ok, Device} = file:open(Def#filedef.filename, [read, binary, {encoding, utf8}]),
    Rows = parse_csv:scan_lines(Device, Def#filedef.colsep),
    file:close(Device),
    file:delete(Def#filedef.filename),

    %% Drop (optionally) the first row, empty rows and the comment rows (starting with a '#')
    Rows1 = lists:filter(fun
                            ([<<$#, _/binary>>|_]) -> false; 
                            ([]) -> false;
                            (_) -> true
                         end,
                         tl(Rows)),
    import_rows(Rows1, Def#filedef.columns, Context).   



import_rows([], _Columns, Context) -> 
    lager:info("[~p] Ginger import: finished importing edges", [z_context:site(Context)]);
import_rows([R|Rows], Columns, Context) ->
    Zipped = zip(R, Columns, []),
    _ = import_row(Zipped, Context),
    import_rows(Rows, Columns, Context).

import_row(Row, Context) ->
    Pred = z_string:to_name(proplists:get_value("predicate", Row)),
    case ensure_predicate(Pred, Context) of
        {ok, Predicate} ->
            import_row_1(Row, Predicate, Context);
        {error, _} = Error ->
            lager:error("[~p] Ginger import: error ensuring predicate ~p : ~p", 
                        [z_context:site(Context), Pred, Error])
    end.

import_row_1(Row, Predicate, Context) ->
    Subject = m_rsc:rid(proplists:get_value("subject", Row), Context),
    Object = m_rsc:rid(proplists:get_value("object", Row), Context),
    Options = case proplists:get_value("order", Row) of
                undefined -> [];
                <<>> -> [];
                [] -> [];
                Order -> [ {seq, z_convert:to_integer(Order)} ]
              end,
    case edge_insert(Subject, Predicate, Object, Options, Context) of
        {ok, _} ->
            ok;
        {error, _} = Error ->
            lager:error("[~p] Ginger import: error inserting edge ~p : ~p", 
                        [z_context:site(Context), Row, Error]),
            Error
    end.

edge_insert(undefined, _, _, _, _Context) ->
    {error, unknown_subject};
edge_insert(_, undefined, _, _, _Context) ->
    {error, unknown_predicate};
edge_insert(_, _, undefined, _, _Context) ->
    {error, unknown_object};
edge_insert(Subject, Predicate, Object, Options, Context) ->
    m_edge:insert(Subject, Predicate, Object, Options, Context).


ensure_predicate(Pred, Context) ->
    case m_rsc:rid(Pred, Context) of
        undefined ->
            Props = [
                {is_published, true},
                {visible_for, 0},
                {category, predicate},
                {title, Pred},
                {name, Pred}
            ],
            case m_rsc:insert(Props, Context) of
                {ok, _Id} ->
                    {ok, Pred};
                {error, _} = Error ->
                    Error
            end;
        Id ->
            case m_rsc:is_a(Id, predicate, Context) of
                true ->
                    {ok, m_rsc:p_no_acl(Id, name, Context)};
                false ->
                    {error, not_a_predicate}
            end
    end.

%% @doc Combine the field name definitions and the field values.
zip(_Cols, [], Acc) -> lists:reverse(Acc);
zip([_C|Cs], [''|Ns], Acc) -> zip(Cs, Ns, Acc);
zip([_C|Cs], [""|Ns], Acc) -> zip(Cs, Ns, Acc);
zip([_C|Cs], [undefined|Ns], Acc) -> zip(Cs, Ns, Acc);
zip([], [N|Ns], Acc) -> zip([], Ns, [{z_convert:to_list(N),<<>>}|Acc]);
zip([C|Cs], [N|Ns], Acc) -> zip(Cs, Ns, [{z_convert:to_list(N), C}|Acc]).

