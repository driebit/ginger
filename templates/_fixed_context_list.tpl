{% if list %}
    <h4 class="section-title">{_ Related _}</h4>
    <ul class="grid">
        {% for id in list %}
            {% with m.rsc[id] as r %}
                {% if r.category_id == m.rsc.collection.id %}
                    {% for part_id in r.o.haspart %}
                        {% catinclude "_grid_item.tpl" part_id counter=forloop.counter %}
                    {% endfor %}
                {% elif r.category_id == m.rsc.query.id %}
                    {% for list_id in m.search[{query query_id=id pagelen=5}] %}
                        {% catinclude "_grid_item.tpl" list_id counter=forloop.counter %}
                    {% endfor %}
                {% else %}
                    {% catinclude "_grid_item.tpl" id counter=forloop.counter %}
                {% endif %}
            {% endwith %}
        {% endfor %}
    </ul>
{% endif %}
