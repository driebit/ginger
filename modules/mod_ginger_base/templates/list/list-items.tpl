{% for i in result %}
    {% with i|is_list|if:(i|element:1):i as item %}
        {% block item %}
            {% if item|is_number %}
                {# A resource #}
                {% if item|is_visible %}
                    {% catinclude list_item_template item %}
                {% endif %}
            {% endif %}
        {% endblock %}
    {% endwith %}
{% endfor %}
