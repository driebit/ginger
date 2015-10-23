{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

    {% with dep_rsc.media|without_embedded_media:id as first_image %}
        {% if first_image %}
            {% catinclude "media/media.tpl" dep_rsc.id %}
        {% endif %}
    {% endwith %}

{% endblock %}
