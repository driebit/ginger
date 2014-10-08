<div class="unlink-wrapper">
    {% if m.edge.s[id][name] %}

        <h4 class="section-title" style="margin-left: 16px;">{_ User contributions _}</h4>
        {% for o_id, edge_id in m.edge.s[id][name] %}
                {% catinclude "_ginger_edit_list_item.tpl" o_id class="col-xs-12" last=forloop.last subject_id=id predicate=name object_id=o_id edge_id=edge_id editable%}
        {% endfor %}

    {% endif %}
</div>
