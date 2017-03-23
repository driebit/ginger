{% overrules %}

{% block no_id %}
    {% if q.object_id %}
        {% with m.collection_object[q.database][q.object_id]._source as record %}
            <meta property="og:title" content="{{ record['dcterms:title'] }}"/>
            <meta property="og:description" content="{{ record['dcterms:abstract']|truncate:160 }}"/>
            <meta property="og:url" content="{{ m.collection_object.uri }}"/>
            {% include "beeldenzoeker/depiction.tpl" width=500 height=500 template="head/facebook-image.tpl" %}
        {% endwith %}
    {% endif %}
{% endblock %}
