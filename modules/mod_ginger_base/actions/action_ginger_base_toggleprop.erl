-module(action_ginger_base_toggleprop).
-author("Dirk Geurs <dirk@driebit.nl").
-include("zotonic.hrl").

%% interface functions
-export([
    render_action/4,
    event/2
]).

render_action(TriggerId, TargetId, Args, Context) ->
    Id = z_convert:to_integer(proplists:get_value(id, Args)),
    Prop = z_convert:to_atom(proplists:get_value(prop, Args)),
    Action = proplists:get_all_values(action, Args),
    Postback = {toggleprop, Id, Prop, Action},
    {PostbackMsgJS, _PickledPostback} = z_render:make_postback(Postback, postback, TriggerId, TargetId, ?MODULE, Context),
    {PostbackMsgJS, Context}.

%% @doc Toggles a property from true to false or the other way around
event(#postback{message={toggleprop, Id, Prop, Action}}, Context) ->
    PropVal = m_rsc:p_no_acl(Id, Prop, Context),
    IsBool = is_boolean(PropVal),
    case {z_acl:rsc_editable(Id, Context), IsBool} of
        {false, _} ->
            z_render:growl_error("Sorry, you have no permission to edit this page.", Context);
        {true, true} ->
            m_rsc:update(Id, [{Prop, (not PropVal)}], Context),
            z_render:wire(Action, Context)
    end.
