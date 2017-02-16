{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

{% if id.is_visible %}
    <li class="list__item--beeldenzoeker {{ extraClasses }}">
        <a href="{{ id.page_url }}">
        	<div class="list__item__wimpel"><i class="icon--collection"></i> {_ Collection _}</div>
            {% block item_image %}
                <div class="list__item__image ">

                    {% image dep_rsc.id mediaclass="list-image" alt="" title="" crop=dep_rsc.crop_center %}
                </div>
            {% endblock %}
            <div class="list__item__content">
                {% block item_meta %}
                    <div class="list__item__content__meta">
                        <time datetime="{{ id.publication_start|date:"Y-F-jTH:i" }}" class="list__item__content__date">{{ id.publication_start|date:"j M Y" }}</time>
                    </div>
                {% endblock %}
                {% block item_title %}
                    <h3 class="list__item__content__title">{{ id.title }}</h3>
                {% endblock %}
                {% block item_summary %}
                    {{ id|summary:100 }}
                {% endblock %}
            </div>
        </a>
    </li>
{% endif %}
{% endblock %}