{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

{% if id.is_visible %}

    <li class="{% block class %} list__item--vertical{% endblock %} {{ extraClasses }}">

        <a href="{{ id.page_url }}">
            <article class="cf">
                <div class="list__item--vertical__image" style="background-image: url({% image_url dep_rsc.id mediaclass="list-image" %});">
                    {% image dep_rsc.id mediaclass="list-image" class="list__item__image" alt="" title="" crop=dep_rsc.crop_center %}
                    {% block list_item_cat %}
                        <div class="list__item__content__category">
                            <i class="icon--{{ id.category.name }}"></i>{{ m.rsc[id.category.id].title }}
                        </div>
                    {% endblock %}
                </div>

                {% block list_item_meta %}{% endblock %}

                <div class="list__item__content">
                    {% block list_item_location %}
                        {% with
                            id.o.located_in,
                            id.o.presented_at
                        as
                            located,
                            presented
                        %}

                            {% with located|make_list++presented|make_list|is_visible as locations %}

                                {% if locations %}
                                    <p class="list__item__locations">
                                        {_ Location _}:
                                        {% for r in locations %}
                                            {{ r.title }}{% if not forloop.last %}, {% endif %}
                                        {% endfor %}
                                    </p>
                                {% endif %}

                            {% endwith %}

                        {% endwith %}
                    {% endblock %}

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

{% endif %}

{% endblock %}
