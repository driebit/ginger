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
{% with edgeLocation|default:edgePresented|default:id as location %}{{ location|pprint }}
    {% if location.address_city %}
    
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
{% endwith %}