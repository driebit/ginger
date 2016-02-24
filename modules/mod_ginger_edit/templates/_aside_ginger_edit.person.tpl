<aside>
    {% if m.rsc["hasbanner"] %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="image" predicate="hasbanner" tab="upload" tabs_enabled=["upload","find"] %}
    {% endif %}
    {% if m.rsc["hasprofilepicture"] %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="image" predicate="hasprofilepicture" tab="upload" tabs_enabled=["upload","find"] %}
    {% endif %}
</aside>
