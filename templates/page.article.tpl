{% extends "page.tpl" %}
{% block below_body %}
    {% if id.is_editable %}
        {% include "button_add_media.tpl" %}
    {% endif %}
{% endblock %}
