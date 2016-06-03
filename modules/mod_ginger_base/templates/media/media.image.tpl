<figure class="align-{{ align }}" >
    {% with caption|default:m.rsc[id].summary as caption %}

        {% if link %}
             <a href="{{ id.page_url }}" class="media--image {{ extraClasses }}
            "
            {% if id.title %}
                title="{{ id.title }}"
            {% elif caption %}
                title = "{{ caption }}"
            {% endif %}
            >
        {% else %}
            <a href="{% image_url id.id %}" class="media--image__lightbox lightbox" rel="body" title="{{ caption }}">
        {% endif %}

            {% if id.medium.width > 750 %}
                {% image id.id mediaclass="landscape-"++sizename alt="" crop=id.crop_center %}
            {% elif id.medium.height > 750 %}
                 {% image id.id mediaclass="portrait-"++sizename alt="" crop=id.crop_center %}
            {% elif sizename %}
                {% image id.id mediaclass="landscape-"++sizename alt="" crop=id.id.crop_center %}
            {% else %}
                {% image id.id mediaclass="landscape-large" alt="" crop=id.id.crop_center %}
            {% endif %}

            </a>

        {% block figcaption %}
            {% if caption or id.o.actor %}
                <figcaption>
                    <p>{{ caption }}{% if m.rsc[id].o.author %} {_ By: _} <a href="{{ m.rsc[m.rsc[id].o.author[1]].page_url }}">{{ m.rsc[m.rsc[id].o.author[1]].title }}</a>{% endif %}</p>
                    {% include "copyrights/copyrights.tpl" %}
                    {% include "person/actors.tpl" title=_"With:" %}
                </figcaption>
            {% endif %}
        {% endblock %}
    {% endwith %}
</figure>
