{% if record['dbpedia-owl:notes'] as notes %}
    <dt>{_ Notes _}</dt>
    <dd>
        <ul>
        {% for note in notes %}
            <li>{{ note }}</li>
        </ul>
        {% endfor %}
    </dd>
{% endif %}
