{% if location %}
    <div class="page__content__about page__content__about--location">
        <h3 class="page__content__about__header">{{ title }}</h3>
        <p class="page__content__about__content">
            {{ location.title }}<br>

            {% if location.address_street_1 %}
                {{ location.address_street_1 }}
            {% endif %}
            {% if location.address_street_2 %}
                {{ location.address_street_2 }}
            {% endif %}
            {% if location.address_street_1 or location.address_street_2 %}
                ,
            {% endif %}
            {% if location.address_postcode %}
                {{ location.address_postcode }}
            {% endif %}
            {% if location.address_city %}
                {{ location.address_city }}
            {% endif %}
        </p>

        {% if location.location_lat and location.location_lng %}
            <p class="page__content__about__link">
                <a href="http://maps.google.com/maps?q=loc:{{ location.location_lat }}+{{ location.location_lng }}" target="_blank">Toon kaart</a>
            </p>
        {% endif %}
    </div>
{% endif %}
