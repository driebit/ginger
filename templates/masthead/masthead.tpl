{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

<style>
.masthead {
    background-size: cover;
    height: 300px;
}
</style>

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

        {% if dep_rsc %}
            {% if dep_rsc.medium.width > 500 and dep_rsc.name|lower != "fallback" %}
                <div class="masthead do_parallax" style="background-image: url({% image_url dep_rsc.id mediaclass='masthead' crop %}); background-size: cover;"></div>
            {% else %}
                <div class="masthead"></div>
            {% endif %}
        {% else %}
            <div class="masthead"></div>
        {% endif %}

    {% endif %}

{% endif %}

{% endblock %}
