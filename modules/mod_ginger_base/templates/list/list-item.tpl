{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

{% if id.is_published or m.acl.is_allowed.use.mod_admin %}
<li class="list__item {{ extraClasses }}">

    {% include "page-actions/page-action-edit-thing.tpl" extraClasses="edit-button--list-item" id=id %}

    <a href="{{ id.page_url }}">
        <article>
            {% image dep_rsc.id mediaclass="list-image" class="list__item__image" alt="" title="" crop=dep_rsc.crop_center %}
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

                {% if id.summary %}
                    <p>{{ id.summary|striptags|truncate:100 }}</p>
                {% else %}
                    <p>{{ id.body|striptags|truncate:100 }}</p>
                {% endif %}

                {% block list_item_location %}{% endblock %}
            </div>
        </article>
    </a>
</li>

{% endif %}
{% endblock %}

