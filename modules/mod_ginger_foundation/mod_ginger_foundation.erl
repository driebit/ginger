%% @author Driebit <info@driebit.nl>
%% @copyright 2014

-module(mod_ginger_foundation).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger Foundation").
-mod_description("Foundation styling for Ginger websites").
-mod_prio(100).

-export([observe_rsc_update/3]).

-include("zotonic_notifications.hrl").

observe_rsc_update(#rsc_update{id=Id}, {_IsChanged, UpdateProps} = Acc, Context) ->
    case m_rsc:is_a(Id, category, Context) of
        true ->
            case proplists:get_value(feature_enable_comments, UpdateProps) of
                undefined ->
                    {true, [{feature_enable_comments, false}|UpdateProps]};
                Value ->
                    BoolValue = z_convert:to_bool(Value),
                    ReplacedProps = lists:keyreplace(feature_enable_comments,
                                                     1,
                                                     UpdateProps,
                                                     {feature_enable_comments, BoolValue}),
                    {true, ReplacedProps}
            end;
        false -> Acc
    end.
