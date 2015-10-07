{% extends "list/list-item-vertical.tpl" %}

{% block class %} list__item--vertical--event{% endblock %}

{% block list_item_meta %}
    <div class="list__item__content__meta">
        {# <div class="list__item__content__category">
            <i class="icon--{{ id.category.name }}"></i>{{ m.rsc[id.category.id].title }}
        </div> #}
        <div class="list__item--vertical__date">
            <time datetime="{{ id.start_date|date:"Y-F-jTH:i" }}" class="list__item__content__date">

                <span class="list__item__content__date__day">{{ id.date_start|date:"D" }}</span>
                {{ id.date_start|date:"j M" }}
                <span class="list__item__content__date__year">{{ id.date_start|date:"Y" }}</span>
            </time>
        </div>
    </div>
{% endblock %}
