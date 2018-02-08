{% if record['schema:width'] as width %}
    <dt>{_ Width _}</dt>
    <dd>{{ width['schema:value'] }} {{ width['schema:unitText'] }}</dd>
{% endif %}
{% if record['schema:height'] as width %}
    <dt>{_ Height _}</dt>
    <dd>{{ width['schema:value'] }} {{ width['schema:unitText'] }}</dd>
{% endif %}
{% if record['schema:depth'] as depth %}
    <dt>{_ Depth _}</dt>
    <dd>{{ depth['schema:value'] }} {{ depth['schema:unitText'] }}</dd>
{% endif %}

{% if record['schema:duration'] as duration %}
    <dt>{_ Duration _}</dt>
    <dd>{{ duration|iso8601 }}</dd>
{% endif %}

{% if record['dcterms:extent'] as extent %}
    <dt>{_ Dimensions _}</dt>
    <dd>{{ extent }}</dd>
{% endif %}
