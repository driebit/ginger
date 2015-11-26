{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

{% if id.is_visible %}

<li class="list__item--member {{ extraClasses }}">

    <a href="{{ id.page_url }}" style="background-image: url({% image_url dep_rsc.id mediaclass="list-image-member" alt="" title="" crop=dep_rsc.crop_center %})">
        <article>
            <div class="list__item__content">
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

{% endif %}

{% endblock %}
