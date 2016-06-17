{% if direction == 'out' %}
    {% for o_id, edge_id in m.edge.o[id][predicate] %}
        {% include "_ginger_rsc_edge.tpl" subject_id=id predicate=predicate object_id=o_id edge_id=edge_id unlink_action=unlink_action %}
    {% endfor %}
{% else %}
    {% for o_id, edge_id in m.edge.s[id][predicate] %}
        {% include "_ginger_rsc_edge.tpl" subject_id=id predicate=predicate object_id=o_id edge_id=edge_id unlink_action=unlink_action %}
    {% endfor %}
{% endif %}
