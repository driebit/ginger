{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}
    <li class="carousel__item" style="display:inline-block; width:25%">
        <a href="{{ id.page_url }}" class="carousel__item__link {{ extraClasses }}">
            {% image dep_rsc.id mediaclass="list-thumbnail" class="img-responsive" alt="" crop=dep_rsc.crop_center %}
        </a>
    </li>
{% endblock %}
