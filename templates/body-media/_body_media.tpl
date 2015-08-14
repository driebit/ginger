{% ifequal align "block" %}
        
        {% ifequal m.rsc[id].medium.mime "text/html-oembed" %}
            <section class="oembed-wrapper">
                    {% media m.rsc[id].medium %}
            </section>
        {% else %}

        <figure class="image-wrapper block-level-image">
            <a href="{% image_url m.rsc[id].medium %}" class="lightbox" rel="fancybox-group"
            {% if id.title %}
                title="{{ id.title }}"
            {% elif id.summary %}
                title = "{{ id.summary }}"
            {% endif %}
            >
                {% image m.rsc[id].medium mediaclass="article-depiction-width" crop=crop class=align link=link alt=m.rsc[id].title %}

                {% if m.rsc[id].summary %}
                    <figcaption>{{ m.rsc[id].summary }}</figcaption>
                {% elif m.rsc[id].title %}
                    <figcaption>{{ m.rsc[id].title }}</figcaption>
                {% endif %}
            </a>
        </figure>
{% endifequal %}
{% else %}
        {% media m.rsc[id].medium width=size.width height=size.height crop=crop class=align link=link alt=m.rsc[id].title %}
{% endifequal %}