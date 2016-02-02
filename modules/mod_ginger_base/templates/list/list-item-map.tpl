{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

<li class="{% block class %} list__item--map{% endblock %} {{ extraClasses }}">

    <a href="{{ id.page_url }}">
        <article class="cf">
            <div class="list__item--map__image" style="background-image: url({% image_url dep_rsc.id mediaclass="list-image-map" %});">
            </div>

            <div class="list__item__content">

                <div class="list__item__content__category">
                    <i class="icon--location"></i>{{ m.rsc[id.category.id].title }}
                </div>

                <h3 class="list__item__content__title">
                    {% if id.short_title %}
                        {{ id.short_title }}
                    {% else %}
                        {{ id.title }}
                    {% endif %}
                </h3>

            </div>

        </article>
    </a>
</li>

{% endblock %}
