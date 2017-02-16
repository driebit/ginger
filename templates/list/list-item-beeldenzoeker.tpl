{% with item._source as record %}
{# {% print record %} #}
    <li class="list__item--beeldenzoeker {{ extraClasses }}">
        <a href="{% url adlib_object object_id=record.priref %}">
            {% block item_image %}
                {% with record.reproduction|first as reproduction %}
                    <div class="list__item__image {% if reproduction %} {% endif %}">
                        {% include "beeldenzoeker/image.tpl" image=reproduction.value width=400 height=400 %}
                    </div>
                {% endwith %}
            {% endblock %}
            <div class="list__item__content">
                {% block item_meta %}
                    <div class="list__item__content__meta">
                        <time datetime="{{ record['production.date.start'] }}">{{ record['production.date.start'] }}{% if record['production.date.end'] and record['production.date.end'] != record['production.date.start'] %}&#8202;–&#8202;{{ record['production.date.end'] }}{% endif %}</time><br>
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
                    {% endif %}
                {% endblock %}
            </div>
        </a>
    </li>
{% endwith %}
