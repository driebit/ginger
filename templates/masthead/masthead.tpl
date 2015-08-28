
{% if id %}

    {% if id.address_street_1 %}
    
        <div class="masthead--map do_masthead_map"
            data-street1="{{ resource.address_street_1 }}"
            data-street2="{{ resource.address_street_2 }}"
            data-city="{{ resource.address_city }}"
            data-postcode="{{ resource.address_postcode }}"
            data-country="{{ resource.address_country }}">
        </div>
    
    {% else %}


        {% with 
            id.o.hasbanner[1].depiction|default:id.depiction as banner %}

            {% if banner %}
                {% if banner.width > 500 %}
                    <div class="masthead do_parallax" style="background-image: url({% image_url banner.id mediaclass='masthead' crop %}); background-size: cover;"></div>
                {% else %}
                    <div class="masthead"></div>
                {% endif %}
            {% else %}
                <div class="masthead"></div>
            {% endif %}

        {% endwith %}

    {% endif %}

{% endif %}


