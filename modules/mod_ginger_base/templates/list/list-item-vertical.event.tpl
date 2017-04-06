{% extends "list/list-item-vertical.tpl" %}

{% block class %} list__item--vertical--event{% endblock %}

{% block list_item_meta %}
    <div class="list__item__content__meta">
        {# <div class="list__item__content__category">
            <i class="icon--{{ id.category.name }}"></i>{{ m.rsc[id.category.id].title }}
        </div> #}
        <div class="list__item--vertical__date">
            <time datetime="{{ id.date_start|date:"Y-m-d" }}" class="list__item__content__date">
            <span class="list__item__content__date__day">{{ id.date_start|date:"D"|truncate:2:" " }}</span>
            {{ id.date_start|date:"j M" }}
            <span class="list__item__content__date__year">{{ id.date_start|date:"Y" }}</span>
            {% if not id.date_is_all_day and id.date_start|date:"H:i"!="00:00" %}
                <span class="list__item__content__date__time">{{ id.date_start|date:"H:i" }}</span>
            {% endif %}
            </time>
        </div>
    </div>
{% endblock %}

{% block list_item_cat %}
    <div class="list__item__content__category">
        <i class="icon--event"></i>{{ m.rsc[id.category.id].title }}
    </div>
{% endblock %}
