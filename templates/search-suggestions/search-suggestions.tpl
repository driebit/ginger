{% if result %}
    {% for result in result|slice:6 %}
        {% with result._source as record %}
            {% if record.reproduction|first as reproduction %}
                <img src="{{ m.config.mod_ginger_adlib.url.value}}?server=images&command=getcontent&value={{ reproduction['reproduction.reference'] }}&width=100&height=100">
            {% endif %}

            <b>{{ record.title }} </b>
            {% for dimension in record.dimension %}
                {# Test nested values #}
                {{ dimension['dimension.type']}}: {{ dimension['dimension.value']}} {{ dimension['dimension.unit']}}
            {% endfor %}
            priref: {{ record.priref }}<br>
        {% endwith %}
    {% endfor %}

   {#  {% for cat in result|group_by:`category_id` %}
        <h4 class="search-suggestions__suggestions__title">{{ cat[1].category_id.title }}</h4>
        <ul>
            {% for id in cat %}
                <li>
                    <a href="{{ id.page_url }}">{{ id.title }}</a>
                </li>
            {% endfor %}
        </ul>
    {% endfor %} #}
{% else %}
    <h4 class="search-suggestions__suggestions__title no-results">{_ Nothing found _}</h4>
{% endif %}

<div class="search-suggestions__suggestions__enter">{_ Press enter to search _}</div>