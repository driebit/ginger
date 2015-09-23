
{% with id.depiction as dep %}
    {% if id.is_a.image %}
            <a href="/image/{{ dep.id.medium.filename }}" class="lightbox" rel="fancybox-group"
             {% if id.title %}
                title="{{ id.title }}"
            {% elif id.summary %}
                title = "{{ id.summary }}"
            {% endif %}
            >
                <figure>
                    {% if id.medium.width > 750 %}
                        {% image id mediaclass="article-depiction-width" class="img-responsive" alt="" crop=dep.id.crop_center %}
                    {% elif id.medium.height > 750 %}
                         {% image id mediaclass="article-depiction-height" class="img-responsive" alt="" crop=dep.id.crop_center %}
                    {% else %}
                        {% image id class="img-auto" alt="" crop=dep.id.crop_center %}
                    {% endif %}
                    <figcaption>{% if id.title %}{{ id.title }}{% endif %}</figcaption>
                </figure>
            </a>
    {% else %}
        {% if id.is_a.document %}
            {% catinclude "_media_item.tpl" id %}
        {% else %}
            <a href="{{ dep.id.page_url }}">
                {% include "_media_item.tpl" id=id %}
            </a>
        {% endif %}
   {% endif %}
{% endwith %}