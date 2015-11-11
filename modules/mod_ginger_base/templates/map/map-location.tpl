{% with 
    id,
    type|default:"map",
    fallback|default:"false",
    recenter|default:"false",
    blackwhite|default:"false",
    main_content_class|default:"foldout"
as
    id,
    type,
    fallback,
    recenter,
    blackwhite,
    main_content_class
%}

    {% if id.category.is_a.location %}
    
           <div class="map--location do_map_location"
                data-street="
                {% if id.address_street_2 %}
                    {{ id.address_street_2 }}
                {% elif id.address_street_1 %}
                    {{ id.address_street_1 }}
                {% endif %}
                "
                data-city="{{ id.address_city }}"
                data-postcode="{{ id.address_postcode }}"
                data-country="{{ id.address_country }}"
                data-main-content-class="{{ main_content_class }}"

                data-options='
                        {
                            "type": "{{ type }}",
                            "fallback": {{ fallback }},
                            "recenter": {{ recenter }},
                            "blackwhite": {{ blackwhite }}
                        }
                    '
            ></div>

    {% endif %}

{% endwith %}