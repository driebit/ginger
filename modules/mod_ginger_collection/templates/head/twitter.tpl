{% overrules %}

{% block no_id %}
    {% if q.object_id %}
        {% with index|default:m.config.mod_ginger_adlib_elasticsearch.index.value as index %}
            {% with m.search[{elastic index=index filter=['_type', q.database] filter=['_id', q.object_id] pagelen=1}]|first as result %}
                {% with result._source as record %}
                    <meta name="twitter:title" content="{{ record['dcterms:title'] }}">
                    <meta name="twitter:description" content="{{ record['dcterms:abstract']|default:record['dcterms:description']|truncate:135 }}">
                    {% include "beeldenzoeker/depiction.tpl" width=200 height=200 template="head/twitter-image.tpl" %}
                {% endwith %}
            {% endwith %}
        {% endwith %}
    {% endif %}

{% endblock %}
