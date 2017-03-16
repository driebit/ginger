{% overrules %}

{% block no_id %}
    {% if q.object_id %}
        {% with index|default:m.config.mod_ginger_adlib_elasticsearch.index.value as index %}
            {% with m.search[{elastic index=index filter=['_type', q.database] filter=['_id', q.object_id] pagelen=1}]|first as result %}
                {% with result._source as record %}
                    <meta property="og:title" content="{{ record['dcterms:title'] }}"/>
                    <meta property="og:description" content="{{ record['dcterms:abstract']|truncate:160 }}"/>
                    <meta property="og:url" content="{% url adlib_object use_absolute_url database=q.database object_id=q.object_id %}"/>
                    {% include "beeldenzoeker/depiction.tpl" width=500 height=500 template="head/facebook-image.tpl" %}
                {% endwith %}
            {% endwith %}
        {% endwith %}
    {% endif %}
{% endblock %}
