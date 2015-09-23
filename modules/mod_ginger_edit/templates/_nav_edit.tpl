<div id="nav-edit" class="nav-edit">
    {% if id.is_editable %}
        {% with id.category_id as cat_id %}
        {% with m.rsc[cat_id].name as cat_name %}
            {% if cat_name=='story' %}
                <a class="btn {% if button == 'small' %}btn-sm {% else %}btn-default {% endif %} {{ extraClasses }}" href="/edit/{{ m.rsc[id].id }}"><span class="glyphicon glyphicon-pencil"></span><span>{_ Edit _}</span></a>
            {% else %}
                <a class="btn {% if button == 'small' %}btn-sm {% else %}btn-default {% endif %} {{ extraClasses }}" href="{% url admin_edit_rsc id=id %}"><span class="glyphicon glyphicon-edit"></span><span>{_ Edit _}</span></a>
            {% endif %}
        {% endwith %}
        {% endwith %}
    {% endif %}
</div>