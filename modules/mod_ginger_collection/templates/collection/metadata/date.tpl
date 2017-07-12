{% with
    record['dbo:productionStartYear']|default:record['dcterms:created']|default:record['dcterms:date']|isodate:"j F Y",
    record['dbo:productionEndYear']|isodate:"j F Y"
as
    start,
    end
%}<time>{{ start }}{% if end and end != start %}&#8202;–&#8202;{{ end }}{% endif %}</time>{% endwith %}
