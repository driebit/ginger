<aside>
    {% if m.rsc.hasbanner.exists %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="image" predicate="hasbanner" tab="new" tabs_enabled=["new","find"] %}
    {% endif %}
    {% if m.rsc.hasprofilepicture.exists %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="image" predicate="hasprofilepicture" tab="new" tabs_enabled=["new","find"] %}
    {% endif %}
</aside>
