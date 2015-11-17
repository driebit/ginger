{% with
    m.rdf[rdf].id,
    m.rdf[rdf].type,
    m.rdf[rdf].uri,
    m.rdf[rdf].title,
    m.rdf[rdf].description,
    m.rdf[rdf].thumbnail,
    m.rdf[rdf].rights
as
    id,
    type,
    uri,
    title,
    description,
    thumbnail,
    rights
%}
<div class="col-lg-4 col-md-4">
    <a href="{{ url }}" target="_blank" class="thumbnail{% if m.rdf_triple.id[subject_id][predicate][uri] %} thumbnail-connected{% endif %}" data-identifier="{{ id }}" data-uri="{{ uri }}" data-title="{{ title }}" data-thumbnail="{{ thumbnail }}">
        {% if thumbnail %}
            <img class="admin-list-overview thumb pull-left" src="{{ thumbnail }}">
        {% endif %}

        {% if rights %}
            {# TODO: show rights as banner? #}
        {% endif %}

        <div class="z-thumbnail-text">
            <h6>{{ type }}</h6>
            <h5>{{ title }}</h5>
            <p>{{ description|truncate:50 }}</p>
        </div>
    </a>
</div>

{% endwith %}
