{% if record['schema:series'] as series %}
    <dt>{_ Series _}</dt>
    <dd>{{ series }}{% if record['schema:position'] as position %}, {{ position }}{% endif %}</dd>
{% endif %}

{% if record['schema:isPartOf'] as parent_publication %}
    <dt>{_ In _}</dt>
    <dd>
        <em>{{ parent_publication['dcterms:title'] }}</em>
        {% if parent_publication['schema:volumeNumber'] as volume %}
            {{ volume }}{% endif %}{% if parent_publication['schema:issueNumber'] as issue %}:{{ issue }}{% endif %}
        {% if (parent_publication['dcterms:date']|isodate:"j F Y")|default:parent_publication['source.publication_years'] as publication_date %}
            (<time>{{ publication_date }}</time>)
        {% endif %}
        {% if parent_publication['schema:pagination'] as pagination %} pp. {{ pagination }}{% endif %}
    </dd>
{% endif %}

{% if record['schema:pagination'] as pagination %}
    <dt>{_ Pagination _}</dt>
    <dd>{{ pagination }}</dd>
{% endif %}

