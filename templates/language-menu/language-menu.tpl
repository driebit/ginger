{% with m.translation.language_list_enabled as languages %}
    {% if languages %}
        <h1>{_ Kies je taal _}</h1>
        <ul>
            {% for code,lang in languages %}
                {% if all or id|is_undefined or (lang.is_enabled and code|member:id.language) %}
                    <li class="{% if code == z_language %}active{% endif %}">
                        <a href="{% url language_select code=code p=m.req.raw_path %}">{{ lang.language }}</a>
                    </li>
                {% endif %}
            {% endfor %}
        </ul>
    {% endif %}
{% endwith %}