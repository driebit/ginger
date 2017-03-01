{% with id.s.haspart|is_visible|exclude:`name` as collections %}
    {% if collections %}
        <p class="part-of">
            <span>{_ Part of: _}</span>
            {% for collection in collections|slice:3 %}
                <a href="{{ collection.page_url }}" class="">{{ collection.title|truncate:60 }}</a>{% if not forloop.last %}, {% endif %}
            {% endfor %}
        </p>
    {% endif %}
{% endwith %}
