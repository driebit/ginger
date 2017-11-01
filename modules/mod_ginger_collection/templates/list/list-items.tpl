{% overrules %}

{% block item %}

    {% inherit %}

    {% if not item|is_number %}
        {# Elasticsearch document #}
        {% if item._type == "resource" %}
            {# A Zotonic resource #}
            {% catinclude list_item_template item._id %}
        {% else %}
            {# An Elasticsearch document #}
            {% include "collection/" ++ list_item_template item=item %}
        {% endif %}
    {% endif %}

{% endblock %}
