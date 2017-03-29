<ul id="{{ list_id }}" class="{{ class }} {{ extra_classes }}">

    {% for i in result %}
        {% with (i|length == 2)|if:(i|element:1):i as item %}
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

</ul>
