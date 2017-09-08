{% if not tabs_enabled or "find"|member:tabs_enabled %}
    <li><a data-toggle="tab" href="#{{ tab }}-linked-data">{_ Linked Data _}</a></li>
{% endif %}
