{% with
    id.o.located_in,
    id.o.presented_at
as
    edgeLocation,
    edgePresented
%}
{% with edgeLocation|default:edgePresented|default:id as location %}
    <div class="meta-location">
        <h4 class="meta-location__header"><i class="icon--location"></i>{_ Location _}</h4>
        <div class="meta-location__content">
            <p>
                <a href="{{ location.page_url }}">{{ location.title }}</a><br>
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
                {% if location.website %}
                    <br><a href="{{ location.website }}" target="_blank">website</a>
                {% endif %}
            </p>
            {% if location.location_lat and location.location_lng %}
                <a href="http://maps.google.com/maps?q=loc:{{ location.location_lat }}+{{ location.location_lng }}" target="_blank" class="meta-location__content__link">{_ Show map _}</a>
            {% endif %}
        </div>
    </div>
{% endwith %}
{% endwith %}
