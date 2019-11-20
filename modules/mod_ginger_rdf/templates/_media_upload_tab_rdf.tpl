{% if m.config.mod_ginger_rdf.source or "find_rdf"|member:tabs_enabled %}
    <li {% if tab == "find_rdf" %}class="active"{% endif %}>
        <a data-toggle="tab" href="#{{ tab }}-linked-data">{_ Linked Data _}</a>
    </li>
{% endif %}
