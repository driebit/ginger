{% if id.is_editable %}
    {% with id.category_id as cat_id %}
    {% with m.rsc[cat_id].name as cat_name %}
    <div class="navbar-right" style="margin-top: 5px;">
        <ul class="nav navbar-nav">
            {% if cat_name=='story' %}
                <a class="btn btn-edit btn-default" href="/edit/{{ m.rsc[id].id }}">{_ Edit _}&nbsp;<i class="glyphicon glyphicon-pencil"></i></a>
            {% else %}
                <a class="btn btn-edit btn-default" href="{% url admin_edit_rsc id=id %}">{_ Edit _}&nbsp;<i class="glyphicon glyphicon-edit"></i></a>
            {% endif %}
        </ul>
    </div>
    {% endwith %}
    {% endwith %}
{% endif %}