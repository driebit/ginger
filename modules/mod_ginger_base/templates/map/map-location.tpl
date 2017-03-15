{# We should refactor the name to map-static! #}

{% with
    id,
    type|default:"map",
    fallback|default:"false",
    recenter|default:"false",
    blackwhite|default:"false",
    main_content_class|default:"foldout",
    id.o.located_in,
    id.o.presented_at
as
    id,
    type,
    fallback,
    recenter,
    blackwhite,
    main_content_class,
    edgeLocation,
    edgePresented
%}
{% with edgeLocation|default:edgePresented|default:id as location %}
{% with 
    lat|default:location.pivot_location_lat,
    lng|default:location.pivot_location_lng 
as 
    lat,
    lng
%}

   <div class="map--location do_map_location"
        data-street="
        {% if location.address_street_2 %}
            {{ location.address_street_2 }}
        {% elif location.address_street_1 %}
            {{ location.address_street_1 }}
        {% endif %}
        "
        data-city="{{ location.address_city }}"
        data-postcode="{{ location.address_postcode }}"
        data-country="{{ location.address_country }}"
        data-main-content-class="{{ main_content_class }}"
        data-lat="{{ lat }}"
        data-lng="{{ lng }}"
        data-options='
                {
                    "type": "{{ type }}",
                    "fallback": {{ fallback }},
                    "recenter": {{ recenter }},
                    "blackwhite": {{ blackwhite }},
                    "gridsize": "60"
                }
            '
    ></div>
{% endwith %}
{% endwith %}
{% endwith %}
