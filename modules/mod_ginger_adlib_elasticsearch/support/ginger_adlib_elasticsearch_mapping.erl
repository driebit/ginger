%% @doc Default
-module(ginger_adlib_elasticsearch_mapping).

-export([
    map/1,
    map_property/3,
    year/1,
    to_list/1,
    to_labelled_list/1
]).

-include_lib("zotonic.hrl").

-callback map_property(Property :: binary(), Value :: binary(), Acc :: map()) -> NewAcc :: map().

map(Record) ->
    Record.

map_property(Key, [#{<<"value">> := Value}], Acc) ->
    %% Flatten Adlib's @lang/value xmltype=grouped structure.
    map_property(Key, Value, Acc);
map_property(Key, #{<<"value">> := Value}, Acc) ->
    %% Flatten Adlib's @lang/value xmltype=grouped structure.
    map_property(Key, Value, Acc);
map_property(Key, Value, Acc) when Key =:= <<"object_number">>; Key =:= <<"object.object_number">> ->
    Acc#{
        <<"dcterms:identifier">> => Value
    };
map_property(<<"creator">>, Value, Acc) ->
    Acc#{<<"rdfs:label">> => Value};
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
map_property(<<"reproduction.creator">>, Value, Acc) ->
    Acc#{<<"dcterms:creator">> => Value};
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
map_property(<<"rights">>, Value, Acc) ->
    Acc2 = Acc#{<<"rights">> => Value},
    case m_creative_commons:url_for(Value) of
        undefined ->
            Acc2;
        Url ->
            Acc2#{<<"dcterms:license">> => Url}
    end;
map_property(Key, [Value], Acc) ->
    map_property(Key, Value, Acc);
map_property(Key, Value, Acc) ->
    Acc#{Key => Value}.

map_dimension(#{<<"dimension.type">> := Type, <<"dimension.unit">> := Unit, <<"dimension.value">> := Value}, Acc) ->
    Acc#{map_dimension_type(Type) => #{
        <<"rdf:type">> => <<"schema:QuantitativeValue">>,
        <<"schema:value">> => Value,
        <<"schema:unitCode">> => map_dimension_unit(Unit),
        <<"schema:unitText">> => Unit
    }}.

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
    %% TODO: is this correct?
    <<"schema:height">>;
map_dimension_type(<<"diameter">>) ->
    <<"dbpedia-owl:diameter">>;
map_dimension_type(Type) ->
    Type.

to_list(Values) when is_list(Values) ->
    Values;
to_list(Value) ->
    %% Wrap single value in a list for consistency
    [Value].

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
