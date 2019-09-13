{% if caption or id.o.actor %}
    <figcaption>
        {% if caption == "-" %}{% else %}
            <p>{{ caption }}{% if id.o.author %} {_ By: _} <a href="{{ id.o.author[1].page_url }}">{{ id.o.author[1].title }}</a>{% endif %}</p>
        {% endif %}
        {% include "copyrights/copyrights.tpl" %}
        {% include "person/actors.tpl" title=_"With:" %}
    </figcaption>
{% endif %}
