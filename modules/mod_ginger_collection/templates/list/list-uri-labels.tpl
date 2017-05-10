<ul>
{% for item in items %}
    {% if item['@id'] as uri %}
        {% if
            (m.erfgoedthesaurus[uri].definition|filter:`language`:"dut"|first)
        as
            erfgoedthesaurus_definition
        %}
            <dl>
                <dt>{{ item['rdfs:label'] }}</dt>
                <dd>{{ erfgoedthesaurus_definition.value }}</dd>
            </dl>
        {% else %}
            <li>
                <a href="">{{ item['rdfs:label']|default:item['@id'] }}</a>
            </li>
        {% endif %}
    {% else %}
        <li>{{ item['rdfs:label'] }}</li>
    {% endif %}
{% endfor %}
</ul>
