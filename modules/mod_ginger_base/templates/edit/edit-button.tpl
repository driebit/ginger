<a class="edit-button {{ extraClasses }}" href="
    {% if id.is_editable %}
        {% url admin_edit_rsc id=id %}
    {% else %}
        /edit/{{ m.rsc[id].id }}
    {% endif %}
" title="{_ Edit page _}" >
{% block label %}
    {_Edit_}
{% endblock %}
</a>