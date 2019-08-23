{% if caption or id.o.actor %}
    <figcaption>
        {% if caption == "-" %}{% else %}
            <p>{{ caption }}{% if m.rsc[id].o.author %} {_ By: _} <a href="{{ m.rsc[m.rsc[id].o.author[1]].page_url }}">{{ m.rsc[m.rsc[id].o.author[1]].title }}</a>{% endif %}</p>
        {% endif %}
        {% include "person/actors.tpl" title=_"With:" %}
    </figcaption>
{% endif %}
