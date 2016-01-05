<aside>
    {% if m.rsc["hasbanner"] %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="image" predicate="hasbanner" %}
    {% endif %}
    {% if m.rsc["hasprofilepicture"] %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="image" predicate="hasprofilepicture" %}
    {% endif %}
</aside>
