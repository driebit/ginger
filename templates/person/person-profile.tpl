{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

    <div class="person-profile">

    {% if dep_rsc %}
        {% image dep_rsc.id mediaclass="avatar" class=image_class %}
    {% endif %}

    </div>

{% endblock %}