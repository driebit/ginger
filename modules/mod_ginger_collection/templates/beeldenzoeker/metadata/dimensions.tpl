{% if record['schema:width'] or record['schema:height'] %}
    {% if record['schema:width'] as width %}
        <dt>{_ Width _}</dt>
        <dd>{{ width['schema:value'] }} {{ width['schema:unitText'] }}</dd>
    {% endif %}
    {% if record['schema:height'] as width %}
        <dt>{_ Height _}</dt>
        <dd>{{ width['schema:value'] }} {{ width['schema:unitText'] }}</dd>
    {% endif %}
{% endif %}
