{# Show an edge object with an unlink option.lled after disconnecting #}

{% with m.rsc[object_id].title as title %}
{% sortable id=#unlink_wrapper tag=edge_id %}
<li id="{{ #unlink_wrapper }}" class="menu-item">
    <div>
	    <i class="z-icon z-icon-drag"></i>
        <a id="{{ #edit }}" href="#">
            {% catinclude "_rsc_edge_item.tpl" object_id %}
       	</a>
        <button type="button" id="{{ #unlink }}" title="{_ Disconnect _}" class="z-btn-remove"></button>
    </div>
</li>
{% endwith %}
{% if direction == "out" %}
    {% wire id=#unlink
        action={unlink
            subject_id=subject_id
            edge_id=edge_id
            hide=#unlink_wrapper
            action=unlink_action
        }
    %}
{% else %}
    {% wire id=#unlink
        action={unlink
            subject_id=object_id
            edge_id=edge_id
            hide=#unlink_wrapper
            action=unlink_action
        }
    %}
{% endif %}
