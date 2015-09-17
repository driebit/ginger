{% if menu %}
{% with menu_class|default:"global-menu" as class %}
{% with id|menu_trail:menu_id as parents %}
    <ul class="{{ class }} {{ extraClasses }}">
    {% for mid, path, action in menu %}
        {% if mid %}
            {% if mid.is_a.collection and mid.o.haspart %}
                <li class="{{ class }}__dropdown{% if mid|member:parents %} is-active{% endif %}">
                    <a href="{% if context %}/{{ context }}/{{ mid.id }}{%else %}{{ mid.page_url }}{% endif %}">
                        {{ mid.short_title|default:mid.title }}
                    </a>
                    <ul>
                        {% for pid in mid.o.haspart %}
                            {% if pid.is_visible %}
                                <li>
                                    <a href="{% if context %}/{{ context }}/{{ pid.id }}{%else %}{{ pid.page_url }}{% endif %}">
                                        {{ pid.short_title|default:pid.title }}
                                    </a>
                                </li>
                            {% endif %}
                        {% endfor %}
                    </ul>
            {% elif action==`down` %}
                <li class="{{ class }}__dropdown{% if mid|member:parents %} is-active{% endif %}">
                    <a href="{{ mid.page_url }}" class="is-disabled">
                        {{ mid.short_title|default:mid.title }}
                    </a>
                    <ul>
            {% else %}
                {% if mid.is_visible %}
                    <li class="{% if mid|member:parents %} is-active{% endif %}">
                        <a href="{{ mid.page_url }}">
                            {{ mid.short_title|default:mid.title }}
                        </a>
                    </li>
                {% endif %}
            {% endif %}
        {% else %}
            </ul></li>
        {% endif %}
    {% endfor %}
    </ul>
{% endwith %}
{% endwith %}
{% endif %}
