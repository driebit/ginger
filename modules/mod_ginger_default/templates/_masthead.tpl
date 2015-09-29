{% with m.rsc[id].media|without_embedded_media:id as media_without_embedded %}
{% with media_without_embedded[1] as first_media_id %}
{% with m.rsc[id].o.hasicon[1] as icon_id %}

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
        {% if first_media_id or icon_id %}

             {% with m.rsc[first_media_id]|default:m.rsc[icon_id] as dep_rsc %}
                
                {% if dep_rsc and dep_rsc.is_a.image %}

                    {% if dep_rsc.medium.width > 500 %}
                        <div class="page__masthead do_ginger_default_paralax" style="background-image: url({% image_url dep_rsc.id mediaclass='img-header' crop %}); background-size: cover;"></div>
                    {% else %}
                        <div class="page__masthead"></div>
                    {% endif %}
                {% else %}
                    <div class="page__masthead"></div>
                {% endif %}

            {% endwith %}
        {% else %}
            {% if m.rsc[id].header %}
                <div class="page__masthead do_ginger_default_paralax" style="background-image: url({% image_url m.rsc[id].header.id mediaclass='img-header' crop %}); background-size: cover;"></div>
            {% elseif article.header %}
                <div class="page__masthead do_ginger_default_paralax" style="background-image: url({% image_url article.header.id mediaclass='img-header' crop %}); background-size: cover;"></div>
            {% else %}
                <div class="page__masthead"></div>
            {% endif %}
        {% endif %}
    {% endif %}
{% endif %}

{% endwith %}
{% endwith %}
{% endwith %}
