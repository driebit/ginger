<ul>
{% for item in items %}
    {% if item['@id'] as uri %}
        <li>
        	<a href="{{ uri }}">{{ item['rdfs:label']|default:item['@id'] }}</a>
        </li>
    {% else %}
        <li>{{ item['rdfs:label'] }}</li>
    {% endif %}
{% endfor %}
</ul>
