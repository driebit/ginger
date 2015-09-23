{% if m.rsc[id].is_editable %}
    <div id="nav-edit" class="nav-edit">
        <a class="btn {% if button == 'small' %}btn-sm {% else %}btn-sx btn-mini {% endif %}" href="/edit/{{ m.rsc[id].id }}"><span class="glyphicon glyphicon-pencil"></span> {_ Edit _}</a>
    </div>
{% endif %}