%% @doc Default
-module(ginger_adlib_elasticsearch_mapping).

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
map_property(<<"creator">> = Key, [Value], Acc) ->
    Acc#{Key => parse_name(Value)};
map_property(<<"creator">> = Key, Value, Acc) ->
    Acc#{Key => parse_name(Value)};
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
map_property(<<"technique">>, Value, Acc) ->
    Acc#{<<"dbpedia-owl:technique">> => to_labelled_list(Value)};
%% @doc See e.g. http://wikidata.dbpedia.org/page/Q1248830
map_property(<<"material">>, Values, Acc) when is_list(Values) ->
    %% List of materials as single value
    %% @doc See e.g. http://wikidata.dbpedia.org/page/Q1248830
    Acc#{<<"dbpedia-owl:constructionMaterial">> => to_labelled_list(Values)};
map_property(<<"material">>, Value, Acc) ->
    %% Single material as value
    Acc#{<<"rdfs:label">> => Value};
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

map_dimension(#{<<"dimension.type">> := Type} = Dimension, Acc) ->
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
    <<"schema:depth">>;
map_dimension_type(<<"diameter">>) ->
    <<"dbpedia-owl:diameter">>;
map_dimension_type(_Type) ->
    undefined.

parse_name(#{<<"name">> := Name}) ->
    parse_name(Name);
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
    [extract_value(Value) || Value <- Values];
extract_values(Values) ->
    %% Wrap single value in a list for consistency
    [extract_value(Values)].

extract_value(#{<<"value">> := Value}) ->
    Value;
extract_value(Value) ->
    Value.

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
