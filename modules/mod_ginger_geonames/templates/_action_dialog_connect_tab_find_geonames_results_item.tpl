{% with
    m.geonames.uri[place.geonameId],
    place.name,
    place.countryCode,
    place.fcodeName,
    place.population
as
    id,
    name,
    country_code,
    type,
    population
%}
    <div class="col-lg-6 col-md-6">
        <a href="{{ url }}" target="_blank" class="thumbnail{% if m.rdf_triple.id[subject_id][predicate][id] %} thumbnail-connected{% endif %}" data-id="{{ id }}" data-title="{{ name }}">
            <div class="z-thumbnail-text">
                <h6>{{ type }}</h6>
                <h5>{{ name }}{% if country_code %} ({{ country_code }}){% endif %}</h5>
                <p>{% if population %}{_ Population _} {{ population }}{% endif %}</p>
            </div>
        </a>
    </div>
{% endwith %}
