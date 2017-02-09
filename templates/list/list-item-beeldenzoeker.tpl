{% with item._source as record %}
{# {% print record %} #}
    <div class="list__item--beeldenzoeker {{ extraClasses }}">
        <a href="{% url adlib_object id=record.priref %}">
            {% block item_image %}
                {% if record.reproduction|first as reproduction %}
                    <div class="list__item__image">
                        <img src="{{ m.config.mod_ginger_adlib.url.value}}?server=images&command=getcontent&value={{ reproduction['reproduction.reference'] }}&width=600&height=600">
                    </div>
                {% endif %}
            {% endblock %}
            <div class="list-item__content">
                {% block item_title %}
                    <h3 class="list-item__content__title">{{ record.title }}</h3>
                {% endblock %}
                {% block item_meta %}
                    <div class="list-item__content__meta">

                        
                        <time datetime="{{ record['production.date.start'] }}">{{ record['production.date.start'] }} {% if record['production.date.end'] %}{{ record['production.date.end'] }}{% endif %}</time>
                    </div>
                {% endblock %}
                {% block item_summary %}
                    {% if record.AHMteksten['AHM.texts.tekst'] %}
                        <p>
                            {{ record.AHMteksten['AHM.texts.tekst'] }}
                        </p>
                    {% endif %}
                {% endblock %}
            </div>
        </a>
    </div>
{% endwith %}