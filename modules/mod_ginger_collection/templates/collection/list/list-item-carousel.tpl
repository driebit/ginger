{% with item._source as record %}
    <li class="list__item--carousel {{ extraClasses }}">
        <a href="{{ item|collection_object_url }}">
            {% block item_image %}
                {% include "collection/depiction.tpl" record=record width=400 height=400 template="list/list-item-image.tpl" %}
            {% endblock %}

            <div class="list__item__content">
                {% block item_content %}
                    <small>
                        {% if record['dbpedia-owl:museum'] as museum %}
                            {{ museum['rdfs:label'] }}
                        {% endif %}
                    </small>
                    {% block item_title %}
                        <h3 class="list__item__content__title">{% include "collection/title.tpl" title=record['dcterms:title']|default:record.title truncate=40 %}</h3>
                    {% endblock %}
                {% endblock %}
            </div>
        </a>
    </li>
{% endwith %}
