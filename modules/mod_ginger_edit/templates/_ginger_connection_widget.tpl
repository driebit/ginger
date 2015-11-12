
{# Widget for editing connections between rscs #}

{% block widget_content %}
{% with m.rsc[id] as r %}
<div id="unlink-undo-message">
</div>
{% with predicate_ids|default:r.predicates_edit as pred_shown %}

    {% for name, p in m.predicate %}
        {% if p.id|member:pred_shown %}

           <div class="unlink-wrapper">
                {% sorter id=["links",id|format_integer,name]|join:"-"
                          tag={object_sorter predicate=name id=id}
                          group="edges"
                          delegate=`controller_admin_edit`
                %}
                <ul id="links-{{ id }}-{{ name }}" class="tree-list connections-list" data-reload-template="_ginger_edit_rsc_edge_list.tpl">{% include "_ginger_edit_rsc_edge_list.tpl" id=id predicate=name %}</ul>
           </div>

            {% if is_editable %}
                <p>
                  <a id="{{ #connect.name }}" href="#connect">+ {_ add a connection _}</a>
                    {% wire
                       id=#connect.name
                       action={
                          dialog_open
                          template="_action_dialog_connect.tpl"
                          title=[_"Add a connection: ", p.title]
                          subject_id=id
                          predicate=name
                        }
                    %}
                </p>
            {% endif %}
            <hr />
        {% endif %}
    {% endfor %}
{% endwith %}
{% endwith %}
{% endblock %}
