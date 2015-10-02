<aside>
    {% block action_ginger_connections %}

            {% include "aside-connection/aside-add-connection.tpl" id=id cat="image" predicate="hasbanner" %}

            {% include "aside-connection/aside-add-connection.tpl" id=id cat="person" predicate="author" %}

    {% endblock %}
</aside>
