{# Add one or more cat="NAME" to the query below to filter the result #}

{% with m.search[{query cat_exclude=cat_exclude text=q.value pagelen=12}] as result %}
    {% if result %}
        {% for cat in result|group_by:`category_id` %}
            <h4>{{ cat[1].category_id.title }}</h4>
            <ul>
                {% for id in cat %}
                    <li>
                        <a href="{{ id.page_url }}">{{ id.title }}</a>
                    </li>
                {% endfor %}
            </ul>
        {% endfor %}
    {% else %}
        <h4>{_ Nothing found _}</h4>
    {% endif %}
{% endwith %}
