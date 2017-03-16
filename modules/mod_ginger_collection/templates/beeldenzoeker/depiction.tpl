{% with
    record['foaf:depiction'],
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
        {% include "beeldenzoeker/image.tpl" image_reference=depiction.reference %}
    {% else %}
        {# Include template with empty URL #}
        {% include template %}
    {% endif %}
{% endwith %}
