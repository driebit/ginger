{% with
    id,
    fallback_rsc_id
as
    id,
    fallback_rsc_id
%}

    {% with id.depiction.id as depiction_id %}
    {% with id.media|without_embedded_media:id.id as media_without_embedded %}
    {% with media_without_embedded[1] as first_media_id %}
    {% with id.o.hasicon[1] as icon_id %}
    {% with id.o.header[1] as header_id %}
    {% with id.o.hasbanner[1] as banner_id %}
    {% with fallback_rsc_id|default:m.rsc.fallback.id as fallback_id %}

        {% with m.rsc[first_media_id]|default:m.rsc[icon_id]|default:m.rsc[header_id]|default:m.rsc[banner_id]|default:m.rsc[depiction_id]|default:m.rsc[fallback_id] as dep_rsc %}
            {% block with_depiction %}{% endblock %}
        {% endwith %}

    {% endwith %}
    {% endwith %}
    {% endwith %}
    {% endwith %}
    {% endwith %}
    {% endwith %}

{% endwith %}
