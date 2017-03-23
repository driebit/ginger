{% if items %}
    <h4 class="search-suggestions__suggestions__title">{_ Results found _}</h4>
    <ul class="search-suggestions__suggestions__list">
        {% for result in items|slice:6 %}
            {% with result._source as item %}
                <li>
                    <a href="{% if item.priref %}{% url adlib_object database=result._type object_id=item.priref %}{% else %}{{ m.rsc[item.id].page_url }}{% endif %}">
                        {% include "beeldenzoeker/depiction.tpl" record=item width=100 height=100 template="search-suggestions/search-suggestions-image.tpl" %}
                        <p class="search-suggestions__suggestions__list__title">{{ item['dcterms:title']|default:m.rsc[item.id].title }} </p>
                    </a>
                </li>
            {% endwith %}
        {% endfor %}
    </ul>
{% else %}
    <h4 class="search-suggestions__suggestions__title no-results">{_ Nothing found _}</h4>
{% endif %}

<div class="search-suggestions__suggestions__enter">{_ Press enter to search _}</div>
