
{# match on objects unfiltered #}

{% with m.search[{match_objects id=id pagelen=5}] as match %}
    {% if match %}
        <h4 class="section-title">{_ Similar pages _}</h4>
        <div class="list-group">
            {% for id, rank in match %}
                {% catinclude "_list_item.tpl" id counter=forloop.counter %}
            {% endfor %}
        </div>
    {% endif %}
{% endwith %}
