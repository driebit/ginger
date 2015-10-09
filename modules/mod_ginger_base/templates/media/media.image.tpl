<figure>

    {% if link %} 
         <a href="{{ id.page_url }}" class="media--image {{ extraClasses }} align-{{ align }}
        " 
        {% if id.title %}
            title="{{ id.title }}"
        {% elif id.summary %}
            title = "{{ id.summary }}"
        {% endif %}
        >
    {% endif %}

        {% if id.medium.width > 750 %}
            {% image id.id mediaclass="article-depiction-width" class="" alt="" crop=id.crop_center %}
        {% elif id.medium.height > 750 %}
             {% image id.id mediaclass="article-depiction-height" class="" alt="" crop=id.crop_center %}
        {% else %}
            {% image id.id mediaclass="default" class="img-auto" alt="" crop=id.id.crop_center %}
        {% endif %}

    {% if link %}
        </a>
    {% endif %}
    
    {% if m.rsc[id].title %}
        <figcaption>{{ m.rsc[id].title }}{% if m.rsc[id].o.author %} {_ By: _} <a href="{{ m.rsc[m.rsc[id].o.author[1]].page_url }}">{{ m.rsc[m.rsc[id].o.author[1]].title }}</a>{% endif %}</figcaption>
    {% elif m.rsc[id].summary %}
        <figcaption>{{ m.rsc[id].summary }}</figcaption>
    {% endif %}

</figure>
