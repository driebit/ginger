{% with m.rsc[id].media|without_embedded_media:id as media_without_embedded %}
{% with media_without_embedded[1] as first_media_id %}
{% with m.rsc[id].o.hasicon[1] as icon_id %}

{% if first_media_id or icon_id %}
    {% with m.rsc[first_media_id]|default:m.rsc[icon_id] as dep_rsc %}
    
        {% if dep_rsc and dep_rsc.is_a.image %}
            {% include "depiction/depiction-image.tpl" %}
        {% else %}
            {% if dep_rsc.is_a.document %}
                {% catinclude "depiction/depiction-media-item.tpl" dep_rsc.id %}
            {% else %}
                <a class="depiction__media-item" href="{{ dep.id.page_url }}">
                    {% include "depiction/depiction-media-item.tpl" dep=dep_rsc %}
                </a>
            {% endif %}
        {% endif %}

    {% endwith %}

{% endif %}

{% endwith %}
{% endwith %}
{% endwith %}