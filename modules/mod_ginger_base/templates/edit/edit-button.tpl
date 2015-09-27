{% with
    class|default:"edit-button"
as
    class
%}
<a class="{{ class }} {{ extraClasses }}" href="
    {% if id.is_editable %}
        {% url admin_edit_rsc id=id %}
    {% else %}
        /edit/{{ m.rsc[id].id }}
    {% endif %}
" title="{_ Edit page _}" >
{% block label %}
    {_ Edit _}
{% endblock %}
</a>

{% endwith %}
