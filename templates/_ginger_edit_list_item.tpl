{# Show an object with an unlink option. Used in the admin_edit #}
{% with m.rsc[object_id] as list_item %}
    {% if list_item.is_visible %}
        {% sortable id=#unlink_wrapper tag=edge_id %}
            
            <div id="{{ #unlink_wrapper }}" class="unlink-wrapper">
                
                {% include "_list_item.tpl" id=list_item last=last %}
                
                <div class="edit-btns">
                    {% if list_item.is_editable %}
                        <a class="btn btn-mini" id="{{ #unlink }}" title="{_ Disconnect _}"><i class="glyphicon glyphicon-remove"></i></button>
                        <a class="btn btn-mini" href="/edit/{{ list_item.id }}" title="{{ title|default:_"Edit" }}"><i class="glyphicon glyphicon-edit"></i></a>
                    {% endif %}
                </div>
            </div>

    {% endif %}
{% endwith %}

{% wire id=#unlink action={unlink subject_id=id edge_id=edge_id hide=#unlink_wrapper} %}
{% wire id=#edit target=#unlink_wrapper action={dialog_edit_basics edge_id=edge_id} %}

{#
 href="{% url admin_edit_rsc id=object_id %}"
 <button id="{{ #edit }}" title="{_ Edit _}" class="btn btn-mini"><i class="icon-edit"></i></button>
#}
