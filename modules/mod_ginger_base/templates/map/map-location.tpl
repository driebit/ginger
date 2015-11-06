{% with 

    id,
    type,
    fallback|default:"false",
    recenter|default:"false"

as

    id,
    type,
    fallback,
    recenter

%}

{# todo: content class for recenter #}

    {% if id.category.name == 'location' and id.address_street_1 %}

           <div class="masthead--map do_map_location"
                data-street1="{{ id.address_street_1 }}"
                data-street2="{{ id.address_street_2 }}"
                data-city="{{ id.address_city }}"
                data-postcode="{{ id.address_postcode }}"
                data-country="{{ id.address_country }}"
                data-main-content-class="foldout"

                data-options='
                        {
                            "type": "{{ type }}",
                            "fallback": {{ fallback }},
                            "recenter": {{ recenter }}
                        }
                    '
            </div>

    {% endif %}

{% endwith %}