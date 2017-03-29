{% for i in items|is_visible %}
    {% with (i|length == 2)|if:(i|element:1):i as item %}
        {% block item %}
            {% if item|is_number %}
                {# A resource #}
                {% catinclude list_item_template item %}
            {% endif %}
        {% endblock %}
    {% endwith %}
{% endfor %}
