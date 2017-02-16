{% with item._source|default:id as record %}
{# {% print record %} #}
    <li class="list__item--beeldenzoeker {{ extraClasses }}">
        <a href="{% if record.priref %}{% url adlib_object object_id=record.priref %}{% else %}{{ id.page_url }}{% endif %}">
            {% if id|is_a:"elastic_query" %}<div class="list__item__wimpel"><i class="icon--collection"></i> {_ Collection _}</div>{% endif %}
            {% block item_image %}
                {% if record.reproduction|first as reproduction %}
                    <div class="list__item__image {% if reproduction %} {% endif %}">
                        {% include "beeldenzoeker/image.tpl" image=reproduction.value width=400 height=400 %}
                    </div>
                {% else %}
                    <div class="list__item__image">
                        <img src="{% image_url id.o.depiction[1].id width="400" height="400" crop=id.o.depiction.id.crop_center %}">
                    </div>
                {% endif %}
            {% endblock %}
            <div class="list__item__content">
                {% block item_meta %}
                    <div class="list__item__content__meta">
                        {% if record['production.date.start'] %}
                            <time datetime="{{ record['production.date.start'] }}">{{ record['production.date.start'] }}{% if record['production.date.end'] and record['production.date.end'] != record['production.date.start'] %}&#8202;–&#8202;{{ record['production.date.end'] }}{% endif %}</time>
                        {% else %}
                            <time datetime="{{ id.publication_start|date:"Y-F-jTH:i" }}" class="list__item__content__date">{{ id.publication_start|date:"j M Y" }}</time>
                        {% endif %}
                    </div>
                {% endblock %}
                {% block item_title %}
                    <h3 class="list__item__content__title">{% include "beeldenzoeker/title.tpl" title=record.title truncate=60 %}</h3>
                {% endblock %}
                {% block item_summary %}
                    {% if record.AHMteksten['AHM.texts.tekst'] %}
                        <p>
                            {{ record.AHMteksten['AHM.texts.tekst']|truncate:"100" }}
                        </p>
                    {% else %}
                        {{ id|summary|truncate:50 }}
                    {% endif %}
                {% endblock %}
            </div>
        </a>
    </li>
{% endwith %}
