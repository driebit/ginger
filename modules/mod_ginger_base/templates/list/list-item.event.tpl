{% extends "list/list-item.tpl" %}

{% block list_item_date %}
    <time datetime="{{ id.start_date|date:"Y-F-jTH:i" }}" class="list__item__content__date">{{ id.date_start|date:"j M Y - H:i" }}</time>
{% endblock %}
