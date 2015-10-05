{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

<li class="list__item--vertical {{ extraClasses }}">
    <a href="{{ id.page_url }}">
        <article class="cf">
            <div class="list__item--vertical__image" style="background-image: url({% image_url dep_rsc.id mediaclass="list-image" %});">
                {% image dep_rsc.id mediaclass="list-image" class="list__item__image" alt="" title="" crop=dep_rsc.crop_center %}
            </div>

            <div class="list__item__content__meta">
                {% block list_item_cat %}
                    <div class="list__item__content__category">
                        <i class="icon--{{ id.category.name }}"></i>{{ m.rsc[id.category.id].title }}
                    </div>
                {% endblock %}
                {% block list_item_date %}
                    <div class="list__item--vertical__date">
                        <time datetime="{{ id.start_date|date:"Y-F-jTH:i" }}" class="list__item__content__date">

                            <span class="list__item__content__date__day">{{ id.date_start|date:"D" }}</span>
                            {{ id.date_start|date:"j M" }}
                            <span class="list__item__content__date__year">{{ id.date_start|date:"Y" }}</span>
                        </time>
                    </div>
                {% endblock %}
            </div>
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
