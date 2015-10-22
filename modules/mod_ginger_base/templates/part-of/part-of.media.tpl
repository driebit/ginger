{% with id.s.depiction as rscs %}
    {% if rscs %}
        <p class="part-of">
            <span>{_ Part of: _}</span>
            {% for rsc in rscs %}
                <a href="{{ rsc.page_url }}" class="">{{ rsc.title|truncate:60 }}</a>{% if not forloop.last %}, {% endif %}
            {% endfor %}
        </p>
    {% endif %}
{% endwith %}
