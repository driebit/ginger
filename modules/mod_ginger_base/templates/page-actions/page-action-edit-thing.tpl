{% if m.acl.user %}
    <a class="page-action--edit {{ extraClasses }}" href="
        {% if id.is_editable and m.acl.is_allowed.use.mod_admin %}
            {% url admin_edit_rsc id=id %}
        {% elif id.is_editable and not m.acl.is_allowed.use.mod_admin %}
            /edit/{{ m.rsc[id].id }}
        {% endif %}
    " title="{_ Edit page _}" >
    {% block label %}
        {_Edit_}
    {% endblock %}
    </a>
{% endif %}