{% if article %}
    {% if type == 'map' %}
        <div class="page__masthead do_ginger_default_masthead_map"
            data-street1="{{ article.address_street_1 }}"
            data-street2="{{ article.address_street_2 }}"
            data-city="{{ article.address_city }}"
            data-postcode="{{ article.address_postcode }}"
            data-country="{{ article.address_country }}"
        ></div>
    {% else %}
        <div class="page__masthead do_ginger_default_paralax"
            {% if article.header %}
                style="background-image: url({% image_url article.header.id mediaclass='img-header' crop %}); background-size: cover;"
            {% else %}
                style="background-image: url({% image_url article.media|first mediaclass='img-header' crop %}); background-size: cover;"
            {% endif %}
        ></div>
    {% endif %}
{% endif %}
