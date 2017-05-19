%% @doc Add date granularity and split-field date editing.
%%      A granular date is a partially known date (relevant particularly for
%%      historical dates). The granularity is either:
%%      - year (e.g. 1984)
%%      - month (June 1984)
%%      - day (15 June 1984)
-module(ginger_date).

-export([
    granularity/1,
    split/2,
    update_granularity/1
]).

-include("zotonic.hrl").

granularity({undefined, _Month, _Day}) ->
    undefined;
granularity({_Year, undefined, undefined}) ->
    <<"year">>;
granularity({_Year, _Month, undefined}) ->
    <<"month">>;
granularity({_Year, _Month, _Day}) ->
    <<"day">>.

split(Name, Date) when is_binary(Name) ->
    split(binary_to_list(Name), Date);
split(Name, {Year, Month, Day}) ->
    [
        {"dt:y:1:" ++ Name, z_convert:to_list(Year)},
        {"dt:m:1:" ++ Name, z_convert:to_list(Month)},
        {"dt:d:1:" ++ Name, z_convert:to_list(Day)}
    ].

%% @doc Update date granularity props based on submitted date part values.
update_granularity(FormProps) ->
    lists:foldr(
        fun({Key, _Value} = Prop, Acc) ->
            case granular_prop(Key) of
                undefined ->
                    [Prop | Acc];
                GranularProp ->
                    Granularity = granularity(
                        {
                            date_value(GranularProp, "y", FormProps),
                            date_value(GranularProp, "m", FormProps),
                            date_value(GranularProp, "d", FormProps)
                        }
                    ),
                    [{Key, Granularity} | Acc]
            end
        end,
        [],
        FormProps
    ).

%% @doc Is the property a date granularity property? These properties they have
%%      a (hidden) input with name="{date_name}_granularity".
granular_prop(Prop) when is_list(Prop) ->
    granular_prop(list_to_binary(Prop));
granular_prop(Prop) ->
    case binary:split(Prop, <<"_granularity">>) of
        [DatePropName, <<>>] ->
            DatePropName;
        _ ->
            undefined
    end.

date_value(Name, Granularity, Props) when is_binary(Name) ->
    date_value(binary_to_list(Name), Granularity, Props);
date_value(Name, Key, Props) ->
    case proplists:get_value("dt:" ++ Key ++ ":0:" ++ Name, Props) of
        NoValue when NoValue =:= undefined; NoValue =:= [] ->
            case proplists:get_value("dt:" ++ Key ++ ":1:" ++ Name, Props) of
                [] ->
                    undefined;
                Value ->
                    Value
            end;
        Value ->
            Value
    end.
