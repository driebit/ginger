{% if items %}
    <div class="person-author__text">
    {{ header }}
    {% for item in items %}
        {% if item.is_visible %}
            <a href="{{ item.page_url }}" class="person-author">
            {% include "avatar/avatar.tpl" dep_rsc=item.depiction %} {{ item.title }}{% if not forloop.last %}, {% endif %}
            </a>
        {% endif %}
    {% endfor %}
    </div>
{% endif %}
