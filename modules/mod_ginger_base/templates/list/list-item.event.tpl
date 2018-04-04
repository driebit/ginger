{% extends "list/list-item.tpl" %}

{% block list_item_date %}

    <time datetime="{{ id.date_start|date:"Y-F-jTH:i" }}" class="list__item__content__date">
        {% if id.date_is_all_day %}
            {{ id.date_start|date:"j M Y" }}
        {% else %}
            {{ id.date_start|date:"j M Y - H:i" }}
        {% endif %}
    </time>

{% endblock %}

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
                    <i class="icon--location"></i>
                    {% for r in locations %}
                        {{ r.title }}{% if not forloop.last %}, {% endif %}
                    {% endfor %}
                </p>
            {% endif %}

        {% endwith %}

    {% endwith %}
{% endblock %}

{% block list_item_cat %}
    <div class="list__item__content__category">
        <i class="icon--event"></i>{{ m.rsc[id.category.id].title }}
    </div>
{% endblock %}
