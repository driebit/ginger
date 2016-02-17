{% if id.o.relation %}
    {% for r in id.o.relation %}
        <a href="{{ r.page_url }}" class="home-button">{% if r.short_title %} {{ r.short_title }}{% else %}{{ r.title }}{% endif %}</a>
    {% endfor %}
{% endif %}
