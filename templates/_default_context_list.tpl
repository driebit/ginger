
{# match on objects of the resource with unique name "default_context" (if exists) #}

{% with m.search[{match_objects id=m.rsc.default_context.id pagelen=5}] as match %}
    {% if match %}
        <h4 class="section-title">{_ Related _}</h4>
        <ul class="grid">
            {% for id, rank in match %}
                {% catinclude "_grid_item.tpl" id counter=forloop.counter %}
            {% endfor %}
        </ul>
    {% endif %}
{% endwith %}
