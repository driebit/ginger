{% with id.o.located_in as edgeLocation %}
{% with edgeLocation|default:id as location %}
    <div class="meta-location">
        <h4 class="meta-location__header"><i class="icon--location"></i>{_ Location _}</h4>
        <div class="meta-location__content">
            <p>
                {{ location.title }}<br>
                {% if location.address_street_1 %}
                    {{ location.address_street_1 }}
                {% endif %}
                {% if location.address_street_2 %}
                    {{ location.address_street_2 }}
                {% endif %}
                {% if location.address_street_1 or location.address_street_2 %},{% endif %}
                {% if location.address_postcode %}
                    {{ location.address_postcode }}
                {% endif %}
                {% if location.address_city %}
                    {{ location.address_city }}
                {% endif %}
            </p>
            {% if location.location_lat and location.location_lng %}
                <a href="http://maps.google.com/maps?q=loc:{{ location.location_lat }}+{{ location.location_lng }}" target="_blank" class="meta-location__content__link">{_ Show map _}</a>
            {% endif %}
        </div>
    </div>
{% endwith %}
{% endwith %}
