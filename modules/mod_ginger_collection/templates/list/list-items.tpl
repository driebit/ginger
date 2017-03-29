{% overrules %}

{% block item %}

    {% inherit %}

    {% if not item|is_number %}
        {# Elasticsearch document #}
        {% if item._type == "resource" %}
            {# A Zotonic resource #}
            {% catinclude list_template item._id item=m.rsc[item._id] %}
        {% else %}
            {# An Elasticsearch document #}
            {% include list_template item=item %}
        {% endif %}
    {% endif %}

{% endblock %}
