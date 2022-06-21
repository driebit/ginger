%% @doc Default
-module(ginger_adlib_elasticsearch2_mapping).

-export([
    map/1,
    map_property/3,
    year/1,
    to_list/1,
    to_labelled_list/1,
    extract_values/1,
    parse_name/1
]).

-include_lib("zotonic.hrl").

-callback map_property(Property :: binary(), Value :: binary(), Acc :: map()) -> NewAcc :: map().

map(Record) ->
    Record.

map_property(Key, [#{<<"value">> := _} | _] = Values, Acc) ->
    E = extract_values(Values),
    %% Flatten Adlib's @lang/value xmltype=grouped structure.
    map_property(Key, E, Acc);
map_property(Key, #{<<"value">> := Value}, Acc) ->
    %% Flatten Adlib's @lang/value xmltype=grouped structure.
    map_property(Key, Value, Acc);
map_property(Key, Value, Acc) when Key =:= <<"object_number">>; Key =:= <<"object.object_number">> ->
    Acc#{
        <<"dcterms:identifier">> => Value
    };
map_property(<<"creator">> = Key, Value, Acc) ->
    Acc#{Key => [ parse_name(Creator) || Creator <- to_list(Value) ]};
map_property(<<"creator.role">>, Value, Acc) ->
    Acc#{<<"role">> => Value};
map_property(<<"production.date.start">> = Key, Value, Acc) when value =/= <<"?">> ->
    Acc2 = Acc#{
        Key => Value,
        <<"dcterms:date">> => Value
    },
    case year(Value) of
        undefined ->
            Acc2;
        Year ->
            Acc2#{<<"dbo:productionStartYear">> => Year}
    end;
map_property(<<"production.date.end">> = Key, Value, Acc) when value =/= <<"?">> ->
    Acc2 = Acc#{
        Key => Value,
        <<"dcterms:date">> => Value
    },
    case year(Value) of
        undefined ->
            Acc2;
        Year ->
            Acc2#{<<"dbo:productionEndYear">> => Year}
    end;
map_property(<<"reproduction.creator">>, [Value], Acc) ->
    map_property(<<"reproduction.creator">>, Value, Acc);
map_property(<<"reproduction.creator">>, Value, Acc) when Value =/= <<>> ->
    Acc#{<<"dcterms:creator">> => parse_name(Value)};
map_property(<<"reproduction.reference">>, Value, Acc) ->
    Acc#{<<"reference">> => Value};
map_property(Key, Values, Acc) when Key =:= <<"Dimension">>; Key =:= <<"dimension">> ->
    lists:foldl(
        fun map_dimension/2,
        Acc,
        to_list(Values)
    );
%% @doc See e.g. http://wikidata.dbpedia.org/page/Q1248830
map_property(<<"material">>, Values, Acc) ->
    %% List of materials as single value
    %% @doc See e.g. http://wikidata.dbpedia.org/page/Q1248830
    Acc#{<<"dbpedia-owl:constructionMaterial">> => to_list(Values)};
map_property(<<"notes">>, Values, Acc) ->
    Acc#{<<"dbpedia-owl:notes">> => to_list(Values)};
map_property(<<"rights">> = Key, Value, Acc) ->
    Acc2 = Acc#{Key => Value},
    case m_creative_commons:url_for(Value) of
        undefined ->
            Acc2;
        Url ->
            Acc2#{<<"dcterms:license">> => Url}
    end;
map_property(<<"dimension.unit">>, Value, Acc) ->
    Acc#{<<"schema:unitCode">> => map_dimension_unit(Value),
        <<"schema:unitText">> => Value
    };
map_property(<<"dimension.value">>, Value, Acc) ->
    Acc#{<<"schema:value">> => Value};
map_property(<<"@attributes">> = Key, #{<<"modification">> := Date} = Value, Acc) ->
    Acc#{
        Key => Value,
        <<"dcterms:modified">> => Date,
        <<"modified">> => Date     %% For sorting together with Zotonic resources
    };
map_property(Key, [Value], Acc) ->
    map_property(Key, Value, Acc);
map_property(Key, Value, Acc) ->
    Acc#{Key => Value}.

map_dimension(#{<<"schema:value">> := _, <<"dimension.type">> := Type} = Dimension, Acc) ->
    Dimension2 = maps:remove(<<"dimension.type">>, Dimension),
    case map_dimension_type(Type) of
        undefined ->
            Acc;
        MappedType ->
            Acc#{MappedType => Dimension2#{
                <<"rdf:type">> => <<"schema:QuantitativeValue">>
            }}
    end;
map_dimension(FreeTextDimension, Acc) when is_binary(FreeTextDimension) ->
    Acc#{<<"dcterms:format">> => FreeTextDimension};
map_dimension(_OtherDimension, Acc) ->
    Acc.


%% @doc Map dimension unit to UN/CEFACT Common Codes for Units of Measurement
map_dimension_unit(<<"cm">>) ->
    <<"CMT">>;
map_dimension_unit(Unit) ->
    Unit.

map_dimension_type(<<"breedte">>) ->
    <<"schema:width">>;
map_dimension_type(<<"diepte">>) ->
    <<"schema:depth">>;
map_dimension_type(<<"hoogte">>) ->
    <<"schema:height">>;
map_dimension_type(<<"lengte">>) ->
    <<"dbpedia-owl:length">>;
map_dimension_type(<<"diameter">>) ->
    <<"dbpedia-owl:diameter">>;
map_dimension_type(_Type) ->
    undefined.

parse_name(#{<<"name">> := Name} = Person) ->
    maps:merge(parse_name(Name), maps:remove(<<"name">>, Person));
parse_name(Name) ->
    case binary:split(Name, <<", ">>) of
        [Last, First] ->
            #{
                <<"rdfs:label">> => <<First/binary, " ", Last/binary>>,
                <<"foaf:firstName">> => First,
                <<"foaf:familyName">> => Last
            };
        _ ->
            #{
                <<"rdfs:label">> => Name
            }
    end.

to_list(Values) when is_list(Values) ->
    Values;
to_list(Value) ->
    %% Wrap single value in a list for consistency
    [Value].

extract_values(Values) when is_list(Values) ->
    lists:filtermap(fun extract_value/1, Values);
extract_values(Values) ->
    %% Wrap single value in a list for consistency
    extract_values([Values]).

extract_value(#{<<"value">> := Value}) ->
    {true, Value};
extract_value(Value) when map_size(Value) =:= 0 ->
    false;
extract_value(Value) ->
    {true, Value}.

to_labelled_list(Values) ->
    ListValues = to_list(Values),
    [#{<<"rdfs:label">> => Value} || Value <- ListValues].

%% @doc Extract YYYY value (removing '?' etc.)
-spec year(binary()) -> binary().
year(Value) ->
    case re:run(Value, "^(\\d+).*$", [{capture, all_but_first, binary}]) of
        {match, [Year]} -> Year;
        _ -> undefined
    end.
