{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}
    <li class="carousel__pager__item">
        <a class="carousel__pager__item__link" data-carousel-id="{{ carousel_id }}" data-slide-index="{{ counter }}" href="#"> 
            {% image dep_rsc.id mediaclass="pager-thumbnail" alt=id.title %}
        </a>
    </li>
{% endblock %}