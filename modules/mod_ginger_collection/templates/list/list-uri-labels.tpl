<ul>
{% for item in items %}
    {% if item['@id'] as uri %}
        <a href="{{ uri }}">
            <li>{{ item['rdfs:label'] }}</li>
        </a>
    {% else %}
        <li>{{ item['rdfs:label'] }}</li>
    {% endif %}
{% endfor %}
</ul>
