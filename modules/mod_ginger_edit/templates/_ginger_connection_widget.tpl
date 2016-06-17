{# Widget for editing connections between rscs #}

{% block widget_content %}
{% with m.rsc[id] as r %}
{% with predicate_ids|default:r.predicates_edit as pred_shown %}
    {% for name, p in m.predicate %}
        {% if p.id|member:pred_shown %}

                {% live template="_ginger_connection_widget_list.tpl"
                    topic={object id=id predicate=name}
                    id=id
                    predicate=name|as_atom
                    button_label=button_label
                    button_class=button_class
                    dialog_title_add=dialog_title_add
                    callback=callback
                    action=action
                    unlink_action=unlink_action
                    list_id=list_id
                    is_editable=is_editable
                    direction=direction
                %}

                <hr />
        {% endif %}
    {% endfor %}
{% endwith %}
{% endwith %}
{% endblock %}
