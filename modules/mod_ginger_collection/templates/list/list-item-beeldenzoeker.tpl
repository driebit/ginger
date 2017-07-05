{% with item._source as record %}
    <li class="list__item--beeldenzoeker {{ extraClasses }}">
        <a href="{% url collection_object database=item._type object_id=record.priref %}">
            {% block item_image %}
                {% include "beeldenzoeker/depiction.tpl" record=record width=400 height=400 template="list/list-item-image.tpl" %}
            {% endblock %}

            <div class="list__item__content">
                {% block item_content %}
                    {% block item_meta %}
                        {% if record['production.date.start'] %}
                            <div class="list__item__content__meta">
                                <time datetime="{{ record['production.date.start'] }}">{{ record['production.date.start'] }}{% if record['production.date.end'] and record['production.date.end'] != record['production.date.start'] %}&#8202;–&#8202;{{ record['production.date.end'] }}{% endif %}</time>
                            </div>
                        {% endif %}
                    {% endblock %}
                    {% block item_title %}
                        <h3 class="list__item__content__title">{% include "beeldenzoeker/title.tpl" title=record['dcterms:title']|default:record.title truncate=60 %}</h3>
                    {% endblock %}
                    {% block item_summary %}
                        {% if record['dcterms:abstract']|default:record['dcterms:description'] as summary %}
                            <p>
                                {{ summary|truncate:"100" }}
                            </p>
                        {% endif %}
                    {% endblock %}
                {% endblock %}
            </div>
        </a>

        {% block read_more %}{% endblock %}
    </li>
{% endwith %}
