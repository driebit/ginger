<div id="nav-edit" class="nav-edit">
    {% if id.is_editable %}
        {% with id.category_id as cat_id %}
        {% with m.rsc[cat_id].name as cat_name %}
            {% if cat_name=='story' %}
                <a class="btn {% if button == 'small' %}btn-sm {% else %}btn-sx btn-mini {% endif %}" href="/edit/{{ m.rsc[id].id }}"><span class="glyphicon glyphicon-pencil"></span> {_ Edit _}</a>
            {% else %}
                <a class="btn {% if button == 'small' %}btn-sm {% else %}btn-sx btn-mini {% endif %}" href="{% url admin_edit_rsc id=id %}"><span class="glyphicon glyphicon-edit"></span> {_ Edit _}</a>
            {% endif %}
        {% endwith %}
        {% endwith %}
    {% endif %}
</div>