<p class="involved_item_keywords">
	{% for id in ids %}
        {% if id and id.is_visible and id.is_published %}
            <span class="list_item_simple">
                <a href="{{ id.page_url }}">
                    {% if id.short_title %}
                        {{ id.short_title }}
                    {% else %}
                        {{ id.title }}
                    {% endif %}
                </a>{% if not forloop.last %},{% endif %}
            </span>
        {% endif %}
	{% endfor %}
</p>
