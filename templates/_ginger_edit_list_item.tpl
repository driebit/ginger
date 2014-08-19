{# Show an object with an unlink option. Used in the admin_edit #}
{% with m.rsc[object_id] as list_item %}
    {% if list_item.is_visible %}
        {% sortable id=#unlink_wrapper tag=edge_id %}
        <li id="{{ #unlink_wrapper }}" class="list-item" style="margin-bottom: 20px; background-color: #ffffff; padding: 2px; height:100px;">
            <div class="">
                <a href="{{ list_item.page_url }}" style="text-decoration: none;">
                    {% if list_item.is_editable %}
                       <img class="grippy" src="/lib/images/grippy.png" alt="" style="float: right; padding: 2px;"/>
                    {% endif %}
                    <h4 class="title" style="margin-bottom:4px;">
                        {{ list_item.title|default:"&mdash;" }}
                    </h4>
                    {% image object_id mediaclass="ginger_edit_list_img" style="padding: 5px; float: left;" %}
                    {{ list_item.id|summary:120 }}
                </a>
                <span class="btns" style="position: absolute; top: 85px; right: 3px;">
                    {% if list_item.is_editable %}
                        <button id="{{ #unlink }}" title="{_ Disconnect _}" class="btn btn-mini"><i class="icon-remove"></i></button>
                        <a class="btn btn-mini" href="/edit/{{ list_item.id }}" title="{{ title|default:_"Edit" }}"><i class="icon-edit"></i></a>
                    {% endif %}
                </span>
            </div>
        </li>
    {% endif %}
{% endwith %}

{% wire id=#unlink action={unlink subject_id=subject_id edge_id=edge_id hide=#unlink_wrapper} %}
{% wire id=#edit target=#unlink_wrapper action={dialog_edit_basics edge_id=edge_id} %}

{#
 href="{% url admin_edit_rsc id=object_id %}"
 <button id="{{ #edit }}" title="{_ Edit _}" class="btn btn-mini"><i class="icon-edit"></i></button>
#}
