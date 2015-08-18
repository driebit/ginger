{# id: the resource #}
{# context: "content" | "related" | "gallery" #}

{% with id.depiction.id as depiction_id %}
{% with id.media|without_embedded_media:id.id as media_without_embedded %}
{% with media_without_embedded[1] as first_media_id %}
{% with id.o.hasicon[1] as icon_id %}

{% if first_media_id or icon_id or depiction_id %}
    {% with m.rsc[first_media_id]|default:m.rsc[icon_id]|default:m.rsc[depiction_id] as dep_rsc %}

    {% if context == "content" %}
        {% if dep_rsc and dep_rsc.is_a.video %}
            {% include "depiction/depiction-media-item.tpl" id=id %}
        {% else %}
            {% include "depiction/depiction-image-content.tpl" dep_rsc=dep_rsc id=id %}
        {% endif %}
    {% endif %}

    {% if context == "related" %}
        {% include "depiction/depiction-image-related.tpl" dep_rsc=dep_rsc id=id %}
    {% endif %}

    {% if context == "gallery" %}
        {% include "depiction/depiction-image-gallery.tpl" dep_rsc=dep_rsc id=id %}
    {% endif %}

    {% endwith %}

{% endif %}

{% endwith %}
{% endwith %}
{% endwith %}
{% endwith %}

