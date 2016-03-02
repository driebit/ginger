

{% if id.is_visible %}

    <li id="parent-{{ id }}" class="{% block class %} list__item-publication{% endblock %} {{ extraClasses }}">
        <article>
            <div class="list__item-publication__intro">
                <div class="list__item-publication__column">
                    <button class="btn--publication-expand do_expand" data-parent="parent-{{ id }}" data-content="content-{{ id }}">{_ expand/contract _}</button>
                    <h2 class="list__item-publication__title">{{ id.title }}</h2>
                    {% include "person/person-author.tpl" %}
                </div>
                <div class="list__item-publication__column">
                    {% image id.depiction.id mediaclass="list-image" class="list__item__image" alt="" title="" crop=dep_rsc.crop_center %}
                </div>
                <div class="list__item-publication__column">
                    <p>{{ id.summary|striptags }}</p>
                </div>
                <button class="btn--publication-expand--mobile do_expand" data-parent="parent-{{ id }}" data-content="content-{{ id }}"><span>{_ expand _}</span><span>{_ contract _}</span></button>
            </div>
            <div id="content-{{ id }}" class="list__item-publication__body">
                {{ id.body|show_media }}
            </div>
        </article>
    </li>

{% endif %}
