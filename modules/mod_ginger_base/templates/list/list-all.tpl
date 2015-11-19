{% if page %}
    {% with m.search[{ginger_search query_id=query_id sort=sort pagelen=9999 page=page }] as result %}
        {% include "list/list.tpl" items=result id=id hide_button=1 %}
    {% endwith %}
{% else %}
    {% with m.search[{ginger_search query_id=query_id sort=sort pagelen=9999 }] as result %}
        {% include "list/list.tpl" items=result id=id hide_button=1 %}
    {% endwith %}
{% endif %}

