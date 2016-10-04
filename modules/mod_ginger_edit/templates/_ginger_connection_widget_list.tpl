{% with list_id|default:("links-" ++ id ++ "-" ++ predicate) as list_id %}
<div class="unlink-wrapper">
    {% sorter id=list_id
              tag={object_sorter predicate=predicate id=id}
              group="edges"
              delegate=delegate|default:`controller_admin_edit`
    %}
    <ul id="{{ list_id }}" class="tree-list connections-list">
      {% include "_ginger_rsc_edge_list.tpl" id=id predicate=predicate unlink_action=unlink_action %}
    </ul>
</div>

{% wire
    name=list_id
    action={update
        target=list_id
        template="_ginger_rsc_edge_list.tpl"
        id=id
        predicate=predicate
        unlink_action=unlink_action
    }
%}
{% endwith %}

