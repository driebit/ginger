{% if m.acl.user and id.is_editable and (m.acl.is_allowed.use.mod_admin or m.acl.is_allowed.use.mod_ginger_edit) %}
    <a class="page-action--edit {{ extraClasses }}" href="
        {% if m.acl.is_allowed.use.mod_admin %}
            {% url admin_edit_rsc id=id %}
        {% else %}
            /edit/{{ m.rsc[id].id }}
        {% endif %}
    " title="{_ Edit page _}" >
    {% block label %}
        {_Edit_}
    {% endblock %}
    </a>
{% endif %}