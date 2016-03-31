<figure class="align-{{ align }}" >

    {% if link %}
         <a href="{{ id.page_url }}" class="media--image {{ extraClasses }}
        "
        {% if id.title %}
            title="{{ id.title }}"
        {% elif id.summary %}
            title = "{{ id.summary }}"
        {% endif %}
        >
    {% else %}
        <a href="{% image_url id.id %}" class="lightbox" rel="body">
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

    {% if caption|default:m.rsc[id].summary as caption %}
        <figcaption><p>{{ caption }}{% if m.rsc[id].o.author %} {_ By: _} <a href="{{ m.rsc[m.rsc[id].o.author[1]].page_url }}">{{ m.rsc[m.rsc[id].o.author[1]].title }}</a>{% endif %}</p> {% include "copyrights/copyrights.tpl" %}</figcaption>
    {% endif %}

</figure>
