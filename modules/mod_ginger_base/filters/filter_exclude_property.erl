%% @doc Exclude data from a list based on a property.
%% To filter out all resources that have a URI matching the URI property in some input set:
%% ```
%% {% with id.o.suggestions|exclude_property:"uri":id.o.references as not_yet_added_suggestions %}
%%     {# ... #}
%% {% endwith %}
%% ```
-module(filter_exclude_property).

-export([
    exclude_property/4
]).

-include("zotonic.hrl").

-spec exclude_property([map() | proplists:proplist()], binary(), #rsc_list{}, z:context()) ->
    [map() | proplists:proplist()].
exclude_property(Input, Property, #rsc_list{} = List, Context) when is_atom(Property) ->
    lists:filter(
        fun(Item) ->
            Value = erlydtl_runtime:find_value(Property, Item, Context),
            case filter_filter:filter(List, Property, Value, Context) of
                [] ->
                    %% No resource with property matching value, so keep it in the results.
                    true;
                _ ->
                    %% At least one matching resource, so remove it from the results.
                    false
            end
        end,
        erlydtl_runtime:to_list(Input, Context)
    );
exclude_property(Input, Property, List, Context) ->
    exclude_property(Input, z_convert:to_atom(Property), List, Context).
