{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

<li class="list__item">

    <a href="{{ id.page_url }}" class=" {{ extraClasses }}">
        <article>
            {% image dep_rsc.id mediaclass="list-image" class="list__item__image" alt="" title="" crop=dep_rsc.crop_center %}
            <div class="list__item__content">
                <h3 class="list__item__content__title">
                    {% if id.short_title %}
                        {{ id.short_title }}
                    {% else %}
                        {{ id.title }}
                    {% endif %}
                </h3>

                {% block list_item_cat %}
                    <div class="list__item__content__category">
                        <i class="icon--{{ id.category.name }}"></i>{{ m.rsc[id.category.id].title }}
                    </div>
                {% endblock %}

                {% block list_item_date %}{% endblock %}

                {% if id.summary %}
                    <p>{{ id.summary|striptags|truncate:100 }}</p>
                {% else %}
                    <p>{{ id.body|striptags|truncate:100 }}</p>
                {% endif %}
            </div>
        </article>
    </a>
</li>

{% endblock %}
