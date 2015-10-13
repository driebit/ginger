{% if id %}

    {% if id.category.name == 'location' and id.address_street_1 %}

        <div class="masthead--map do_masthead_map"
            data-street1="{{ id.address_street_1 }}"
            data-street2="{{ id.address_street_2 }}"
            data-city="{{ id.address_city }}"
            data-postcode="{{ id.address_postcode }}"
            data-country="{{ id.address_country }}"
            data-main-content-class="foldout">
        </div>

    {% else %}

        {% with
            id.o.hasbanner[1].depiction|default:id.o.header[1].depiction|default:id.depiction as banner %}

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
