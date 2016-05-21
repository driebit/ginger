{% with
    m.rdf[rdf].id,
    m.rdf[rdf].type,
    m.rdf[rdf].title,
    m.rdf[rdf].description,
    m.rdf[rdf].thumbnail,
    m.rdf[rdf].rights
as
    id,
    type,
    title,
    description,
    thumbnail,
    rights
%}
<div class="col-lg-6 col-md-6">
    <a href="{{ url }}" target="_blank" class="thumbnail{% if m.rdf_triple.id[subject_id][predicate][id] %} thumbnail-connected{% endif %}" data-id="{{ id }}" data-title="{{ title }}" data-thumbnail="{{ thumbnail }}">
        {% if thumbnail %}
            <img class="admin-list-overview thumb pull-left" src="{{ thumbnail }}">
        {% endif %}

        {% if rights %}
            {# TODO: show rights as banner? #}
        {% endif %}

        <div class="z-thumbnail-text">
            <h6>{{ type }}</h6>
            <h5>{{ title }}</h5>
            <p>{{ description|truncate:100 }}</p>
        </div>
    </a>
</div>

{% endwith %}
