{% with
    record['foaf:depiction']|default:[],
    width,
    height,
    template
as
    depictions,
    width,
    height,
    template
%}
    {% if depictions|object_is_visible|first as depiction %}
        {# Site should ship with this template #}
        {% include "collection/image.tpl" image_reference=depiction.reference %}
    {% else %}
        {# Include template with empty URL #}
        {% include template %}
    {% endif %}
{% endwith %}
