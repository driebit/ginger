{% if id %}

    {% if id.category.name == 'location' and id.address_street_1 %}

        {% include "map/map-location.tpl" id=id type="map" fallback recenter %}  

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
