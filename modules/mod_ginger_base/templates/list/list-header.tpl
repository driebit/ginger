{% if items %}
    <div class="list-header">
        <h2 class="list-header__title">
            {% if r.id %}
                <a href="{{ r.page_url }}">{{ list_title }}</a>
            {% else %}
                {{ list_title }}
            {% endif %}
        </h2>
    </div>
{% endif %}
