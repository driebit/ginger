{% with m.ginger_adlib[record] as record %}
    <li class="list__item {{ extraClasses }}">
        <a href="http://tset.com">
            <article>
                <div class="list__item__image">
                    <img
                        src="{{ m.config.mod_ginger_adlib.url.value }}?server=images&command=getcontent&value={{ record['reproduction.reference'] }}"/>
                </div>
                <div class="list__item__content">
                    {% block list_item_date %}
                        {% if record.production_date %}
                            <time datetime="{{ record.production_date }}">{{ record.production_date }}</time>
                        {% endif %}
                    {% endblock %}

                    <h3 class="list__item__content__title">{{ record['object.title'] }}</h3>

                    <div class="list__item__content__meta">
                        {{ record['reproduction.reference'] }}
                    </div>

                    {% block summary %}{% endblock %}

                    {% block list_item_location %}{% endblock %}

                </div>

            </article>
        </a>
    </li>
{% endwith %}
