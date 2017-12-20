{% if not tabs_enabled or "find"|member:tabs_enabled %}
    <li><a data-toggle="tab" href="#{{ tab }}-collection">{_ Collection _}</a></li>
{% endif %}
