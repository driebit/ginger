{% if places|filter:'geo:lat' as places %}

    <div class="adlib-object__meta__row--map">
        <h6 class="adlib-object__meta__title">
            {_ Locations _}
        </h6>
        <div class="adlib-object__meta__data">
            {% include "list/list-uri-labels.tpl" items=places %}
            {% include "map/map.tpl" result=places %}
        </div>
    </div>
{% endif %}
