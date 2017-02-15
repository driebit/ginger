{% if result %}
    {% for cat in result|group_by:`category_id` %}
        <h4 class="search-suggestions__suggestions__title">{{ cat[1].category_id.title }}</h4>
        <ul>
            {% for id in cat %}
                <li>
                    <a href="{{ id.page_url }}">{{ id.title }}</a>
                </li>
            {% endfor %}
        </ul>
    {% endfor %}
{% else %}
    <h4 class="search-suggestions__suggestions__title no-results">{_ Nothing found _}</h4>
{% endif %}

{# <div class="search-suggestions__suggestions__enter">{_ Press enter to search _}</div> #}
