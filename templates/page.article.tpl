{% extends "page.tpl" %}
{% block below_body %}
    {% if id.is_editable %}
        {% include "button_add_media.tpl" %}
    {% endif %}
{% endblock %}
{% block thumbnails %}
	{% catinclude "_admin_edit_depiction.tpl" id is_editable=0 languages=languages %}
{% endblock %}
