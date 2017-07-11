{% overrules %}

{% block no_id %}
    {% if q.object_id %}
        {% with m.collection_object[q.database][q.object_id]._source as record %}
            <meta name="twitter:title" content="{{ record['dcterms:title'] }}">
            <meta name="twitter:description" content="{{ record['dcterms:abstract']|default:record['dcterms:description']|truncate:135 }}">
            {% include "collection/depiction.tpl" width=200 height=200 template="head/twitter-image.tpl" %}
        {% endwith %}
    {% endif %}

{% endblock %}
