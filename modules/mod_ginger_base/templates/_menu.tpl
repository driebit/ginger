{% if menu %}
{% with menu_class|default:"global-nav__menu" as class %}
{% with id|menu_trail:menu_id as parents %}
    <ul class="{{ class }} {{ extraClasses }}">
    {% for mid, path, action in menu %}
        {% if mid %}
            {% if action==`down` %}
                <li class="{{ class }}__dropdown{% if mid|member:parents %} is-active{% endif %}">
                    <a href="{% if context %}/{{ context }}/{{ mid.id }}{%else %}{{ mid.page_url }}{% endif %}" class="{{ mid.name }}">
                        {{ mid.short_title|default:mid.title }}</a>
                    <ul>
            {% else %}
                <li class="{% if mid|member:parents %} is-active{% endif %}">
                    <a href="{{ mid.page_url }}" class="{{ mid.name }}{% if mid|member:parents %} active{% endif %}" data-target="#">
                        {{ mid.short_title|default:mid.title }}
                    </a>
                </li>
            {% endif %}
        {% else %}
            </ul></li>
        {% endif %}
        {% if forloop.last %}{% include "_menu_extra.tpl" %}{% endif %}
    {% endfor %}
    </ul>
{% endwith %}
{% endwith %}
{% endif %}
