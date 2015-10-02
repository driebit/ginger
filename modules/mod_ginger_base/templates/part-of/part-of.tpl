{% with id.s.haspart as collections %}
    {% if collections %}
        <p class="part-of">
            <span>{_ Is onderdeel van: _}</span>
            {% for collection in collections %}
                <a href="{{ collection.page_url }}" class="">{{ collection.title }}</a>{% if not forloop.last %}, {% endif %}
            {% endfor %}
        </p>
    {% endif %}
{% endwith %}


