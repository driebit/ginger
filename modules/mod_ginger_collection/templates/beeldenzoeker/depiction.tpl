{% with
    record['foaf:depiction'],
    width,
    height,
    template,
    no_image_template
as
    depictions,
    width,
    height,
    template,
    no_image_template
%}
    {% if depictions|first as depiction %}
        {# Site should ship with this template #}
        {% include "beeldenzoeker/image.tpl" image_reference=depiction.reference %}
    {% else %}
        {# Include template with empty URL #}
        {% include template %}
    {% endif %}
{% endwith %}
