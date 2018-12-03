{% if not tabs_enabled or "find_geonames"|member:tabs_enabled %}
    <li {% if tab == "find_geonames" %}class="active"{% endif %}>
        <a data-toggle="tab" href="#{{ tab }}-geonames">{_ GeoNames _}</a>
    </li>
{% endif %}
