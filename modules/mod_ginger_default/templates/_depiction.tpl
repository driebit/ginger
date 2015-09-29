
{% with id.depiction as dep %}
{% with dep|default:id as dep_rsc %}
    {% if dep_rsc.is_a.image %}------
            <a href="/image/{{ dep_rsc.id.medium.filename }}" class="lightbox" rel="fancybox-group"
             {% if dep_rsc.title %}
                title="{{ dep_rsc.title }}"
            {% elif dep_rsc.summary %}
                title = "{{ dep_rsc.summary }}"
            {% endif %}
            >
                <figure>
                    {% if dep_rsc.medium.width > 750 %}
                        {% image id mediaclass="article-depiction-width" class="img-content" alt="" crop=dep_rsc.id.crop_center %}
                    {% elif dep_rsc.medium.height > 750 %}
                         {% image id mediaclass="article-depiction-height" class="img-content" alt="" crop=dep_rsc.id.crop_center %}
                    {% else %}
                        {% image dep_rsc class="img-auto" alt="" crop=dep_rsc.id.crop_center %}
                    {% endif %}
                    <figcaption>{% if dep_rsc.title %}{{ dep_rsc.title }}{% endif %}</figcaption>
                </figure>
            </a>
    {% else %}
        {% if dep_rsc.is_a.document %}
            {% catinclude "_media_item.tpl" dep_rsc %}
        {% else %}
            <a href="{{ dep_rsc.id.page_url }}">
                {% include "_media_item.tpl" id=dep_rsc.id %}
            </a>
        {% endif %}
   {% endif %}
{% endwith %}
{% endwith %}