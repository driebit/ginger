{# width/height 0 means original width/height #}
{% with
    image,
    width,
    height
as
    image,
    width,
    height
%}
    {% if image %}
        <img src="{% include "beeldenzoeker/image-url.tpl" %}">
    {% endif %}
{% endwith %}

