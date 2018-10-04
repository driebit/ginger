%% @doc This module is a bridge between Ginger and mod_elasticsearch.
-module(mod_ginger_elasticsearch).
-author("Driebit <tech@driebit.nl>").

-mod_title("Bridge between Ginger and mod_elasticsearch").
-mod_prio(500).

-mod_depends(mod_ginger_rdf).
-mod_schema(1).

-export([
    rdf_index/1,
    rdf_to_doc/2,
    manage_schema/2
]).

-include_lib("zotonic.hrl").
-include_lib("mod_ginger_rdf/include/rdf.hrl").

rdf_to_doc(#rdf_resource{triples = Triples}, _Context) ->
    #{<<"triples" >> => map_triples(Triples)}.

manage_schema(_, Context) ->
    prepare_rdf_index(Context),
    ok.

map_triples(Triples) ->
    lists:foldr(
        fun(#triple{} = Triple, Acc) ->
            Map = triple_to_map(Triple),
            [Map | Acc]
        end,
        [],
        Triples
    ).

triple_to_map(#triple{subject = Subject, predicate = Predicate, object = Object}) ->
    Map = #{
        <<"subject">> => Subject,
        <<"predicate">> => Predicate
    },
    maps:merge(Map, map_object(Object)).

map_object(#rdf_value{value = {{_, _, _}, {_, _, _}} = Value}) ->
    #{
        <<"object_value">> => [Value],
        <<"object_date">> => Value
    };
map_object(#rdf_value{value = [_V|_Vs] = Values}) ->
    #{
      <<"object_value">> => Values
     };
map_object(#rdf_value{value = Value}) ->
    try
        Date = ginger_date:to_binary(Value),
        #{
            <<"object_date">> => Date,
            <<"object_value">> => [?DEBUG(Date)]
        }
    catch
        error:function_clause ->
            ?DEBUG(Value),
            %% Plain text value.
            #{<<"object_value">> => [Value]}
    end;
map_object(Uri) ->
    #{
        <<"object">> => Uri,
        <<"object_uri">> => Uri
    }.

prepare_rdf_index(Context) ->
    {Version, RdfMapping} = ginger_elasticsearch_rdf_index_mapping:mapping(Context),
    Mappings = [{<<"_default_">>, RdfMapping}],
    elasticsearch_index:upgrade(rdf_index(Context), Mappings, Version, Context).

rdf_index(Context) ->
    <<(elasticsearch:index(Context))/binary, "_rdf">>.
