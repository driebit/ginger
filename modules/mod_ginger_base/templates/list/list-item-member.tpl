{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

<li class="list__item--member {{ extraClasses }}">

    {% include "edit/edit-button.tpl" class="edit-button--list-item" id=id %}

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

{% endblock %}
