{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

<li class="{% block class %} list__item--vertical{% endblock %} {{ extraClasses }}">
    <a href="{{ id.page_url }}">
        <article class="cf">
            <div class="list__item--vertical__image" style="background-image: url({% image_url dep_rsc.id mediaclass="list-image" %});">
                {% image dep_rsc.id mediaclass="list-image" class="list__item__image" alt="" title="" crop=dep_rsc.crop_center %}
            </div>

            {% block list_item_meta %}{% endblock %}

            <div class="list__item__content">
                {% if id.o.located_in %}
                    <p class="list__item__content__location">{_ Location _}: <span>{{ id.o.located_in.title }}</span></p>
                {% endif %}

                <h3 class="list__item__content__title">
                    {% if id.short_title %}
                        {{ id.short_title }}
                    {% else %}
                        {{ id.title }}
                    {% endif %}
                </h3>

                {% if id.summary %}
                    <p>{{ id.summary|striptags|truncate:150 }}</p>
                {% else %}
                    <p>{{ id.body|striptags|truncate:150 }}</p>
                {% endif %}
            </div>
        </article>
    </a>
</li>

{% endblock %}
