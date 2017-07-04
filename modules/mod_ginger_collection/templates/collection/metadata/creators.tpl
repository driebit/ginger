<ol>
    {% for creator in record['dcterms:creator'] %}
    <li>
        {% if creator['@id'] %}<a href="{{ creator['@id'] }}">{% endif %}
            {% if creator['qualifier'] %}
                ({{ creator['qualifier'] }})
            {% endif %}
            {{ creator['rdfs:label'] }}
            {% if creator['role'] %}
                ({{ creator['role'] }})
            {% endif %}
            {% if creator['@id'] %}</a>{% endif %}
    </li>
    {% endfor %}
</ol>
