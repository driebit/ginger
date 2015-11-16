{% with
    m.rdf_resource[rdf].type,
    m.rdf_resource[rdf].url,
    m.rdf_resource[rdf].title,
    m.rdf_resource[rdf].description,
    m.rdf_resource[rdf].thumbnail,
    m.rdf_resource[rdf].rights
as
    type,
    url,
    title,
    description,
    thumbnail,
    rights
%}

<div class="col-lg-4 col-md-4">
    <a href="{{ url }}" target="_blank" class="thumbnail" data-uri="{{ url }}" data-title="{{ title }}" data-thumbnail="{{ thumbnail }}">
        {% if thumbnail %}
            <img class="admin-list-overview thumb pull-left" src="{{ thumbnail }}">
        {% endif %}

        {% if rights %}
        RIGHTS: {{ rights }}
        {% endif %}

        <div class="z-thumbnail-text">
            <h6>{{ type }}</h6>
            <h5>{{ title }}</h5>
            <p>{{ description|truncate:50 }}</p>
        </div>
    </a>

    <a class="btn btn-default" href="#" role="button">Link</a>
</div>

{% endwith %}
