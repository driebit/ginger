{% if items %}
    <h4 class="search-suggestions__suggestions__title">{_ Results found _}</h4>
    <ul class="search-suggestions__suggestions__list">
        {% for result in items|slice:6 %}
            {% with result._source as item %}
                <li>
                    <a href="{% if item.priref %}{% url adlib_object object_id=item.priref %}{% else %}{{ m.rsc[item.id].page_url }}{% endif %}">
                        {% if item.reproduction|first as reproduction %}
                            <div class="search-suggestions__suggestions__img" style="background-image: url({{ m.config.mod_ginger_adlib.url.value}}?server=images&command=getcontent&value={{ reproduction['reproduction.reference'] }}&width=100&height=100)"></div>
                        {% else %}
                            <div class="search-suggestions__suggestions__img" style="background-image: url({% image_url id.o.depiction[1].id width="400" height="400" crop=id.o.depiction.id.crop_center %})"></div>
                        {% endif %}
                        <p class="search-suggestions__suggestions__list__title">{{ item.title|default:m.rsc[item.id].title }} </p>
                    </a>
                </li>
            {% endwith %}
        {% endfor %}
    </ul>
{% else %}
    <h4 class="search-suggestions__suggestions__title no-results">{_ Nothing found _}</h4>
{% endif %}

<div class="search-suggestions__suggestions__enter">{_ Press enter to search _}</div>
