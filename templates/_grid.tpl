{% if items %}
    {% if title %}
        <h4 class="section-title">{{ title }}</h4>
    {% endif %}

    <ul class="grid {{ class }}">
        {% for id in items %}
            {% catinclude "_grid_item.tpl" id counter=forloop.counter %}
        {% endfor %}
    </ul>
{% endif %}