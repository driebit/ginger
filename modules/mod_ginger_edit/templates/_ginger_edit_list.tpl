{% for o_id, edge_id in m.edge.o[id][predicate] %}
   {% include "_ginger_edit_list_item.tpl" subject_id=id predicate=predicate object_id=o_id edge_id=edge_id %}
{% endfor %}
