{# Add one or more cat="NAME" to the query below to filter the result #}

{% with m.search[{query cat_exclude=cat_exclude content_group=cg_name text=q.value pagelen=12}] as result %}
    {% if result %}
        {% for cat in result|group_by:`category_id` %}
            <h4>{{ cat[1].category_id.title }}</h4>
            <ul>
                {% for id in cat %}
                    <li>
                        <a href="{{ id.page_url }}">{% if id.title %}{{ id.title }}{% elif id.summary %}{{ id.summary|truncate:30}{% elif id.body %}{{ id.body|truncate:30}{% endif %}</a>
                    </li>
                {% endfor %}
            </ul>
        {% endfor %}
    {% else %}
        <h4>{_ Nothing found _}</h4>
    {% endif %}
{% endwith %}