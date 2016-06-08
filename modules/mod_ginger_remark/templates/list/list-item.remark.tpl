{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

{% if id.is_visible %}

    <li class="list__item {{ extraClasses }}">

        {% include "page-actions/page-action-edit-thing.tpl" extraClasses="edit-button--list-item" id=id %}

        <a href="{{ id.o.about.page_url }}">
            <article>
                <div class="list__item__image">
                    {% image dep_rsc.id mediaclass="list-image" alt="" title="" crop=dep_rsc.crop_center %}
                </div>
                <div class="list__item__content">
                    {% block list_item_date %}
                        {% if id.publication_start %}
                            <time datetime="{{ id.publication_start|date:"Y-F-jTH:i" }}" class="list__item__content__date">{{ id.publication_start|date:"j M Y" }}</time>
                        {% endif %}
                    {% endblock %}

                    <h3 class="list__item__content__title">
                        {% if id.short_title %}
                            {{ id.short_title }}
                        {% else %}
                            {{ id.title }}
                        {% endif %}
                    </h3>

                    <div class="list__item__content__meta">
                        {% block list_item_cat %}
                            <div class="list__item__content__category">
                                <i class="icon--{{ id.category.name }}"></i>{{ m.rsc[id.category.id].title }}
                            </div>
                        {% endblock %}
                    </div>

                    {% block summary %}
                        {% if id.summary %}
                            <p>{{ id.summary|striptags|truncate:50 }}</p>
                        {% else %}
                            <p>{{ id.body|striptags|truncate:50 }}</p>
                        {% endif %}
                    {% endblock %}

                    <p class="list__item__about">
                        <i class="icon--comment"></i>{_ This is a remark on _}: <a href="{{ id.o.about.page_url }}"> {{ id.o.about.title }}</a>
                    </p>

                </div>
            </article>
        </a>
    </li>

{% endif %}

{% endblock %}
