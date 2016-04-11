{% if id.o.actor as actors %}
    <div class="actors">
        {% if title %}{{ title }} {% endif %}
        {% for r in actors %}
            {% if r.is_visible %}
                <a href="{{ author.page_url }}" class="actor">{{ r.title }}{% if not forloop.last %}, {% endif %}</a>
            {% endif %}
        {% endfor %}
    </div>
{% endif %}
