{% with
    id
as
    id
%}

    {% with id.depiction.id as depiction_id %}
    {% with id.media|without_embedded_media:id.id as media_without_embedded %}
    {% with media_without_embedded[1] as first_media_id %}
    {% with id.o.hasicon[1] as icon_id %}
    {% with m.rsc.fallback.id as fallback_id %}

    {% if first_media_id or icon_id or depiction_id or fallback_id %}

        {% with m.rsc[first_media_id]|default:m.rsc[icon_id]|default:m.rsc[depiction_id]|default:m.rsc[fallback_id] as dep_rsc %}

            {% block with_depiction %}{% endblock %}

        {% endwith %}

    {% endif %}

    {% endwith %}
    {% endwith %}
    {% endwith %}
    {% endwith %}
    {% endwith %}

{% endwith %}