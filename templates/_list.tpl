{% if items %}
    {% if title %}
        <h4 class="section-title">{{ title }}</h4>
    {% endif %}

    <ul class="list list-{{ class }}">
        {% for id in items %}
            <li class="list_item">
                <a href="{{ id.page_url }}">{{ id.title }}</a>
            </li>
        {% endfor %}
    </ul>
{% endif %}