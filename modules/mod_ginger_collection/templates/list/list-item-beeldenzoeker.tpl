{% with item._source as record %}
    <li class="list__item--beeldenzoeker {{ extraClasses }}">
        <a href="{% block link %}{% url collection_object database=item._type object_id=record.priref %}{% endblock %}"{% if link_target %} target="{{ link_target }}"{% endif %}>
            {% block item_image %}
                {% include "collection/depiction.tpl" record=record width=400 height=400 template="list/list-item-image.tpl" %}
            {% endblock %}

            <div class="list__item__content">
                {% block item_content %}
                    {% block item_meta %}
                        {% if record['dbo:productionStartYear'] %}
                            <div class="list__item__content__meta">
                                {% include "collection/metadata/date.tpl" %}
                            </div>
                        {% endif %}
                    {% endblock %}
                    {% block item_title %}
                        <h3 class="list__item__content__title">{% include "collection/title.tpl" title=record['dcterms:title']|default:record.title truncate=60 %}</h3>
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
