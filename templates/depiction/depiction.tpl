{% with m.rsc[id].media|without_embedded_media:id as media_without_embedded %}
{% with media_without_embedded[1] as first_media_id %}
{% with m.rsc[id].o.hasicon[1] as icon_id %}

{% if first_media_id or icon_id %}
    {% with m.rsc[first_media_id]|default:m.rsc[icon_id] as dep_rsc %}
    
        {% if dep_rsc and dep_rsc.is_a.image %}
            <a href="/image/{{ dep_rsc.id.medium.filename }}" class="depiction lightbox" rel="fancybox-group"
                {% if dep_rsc.title %}
                    title="{{ dep_rsc.title }}"
                {% elif dep_rsc.summary %}
                    title = "{{ dep_rsc.summary }}"
                {% endif %}
            >
                <figure>
                    {% if dep_rsc.medium.width > 750 %}
                        {% image dep_rsc.id mediaclass="article-depiction-width" class="img-responsive" alt="" crop=dep_rsc.crop_center %}
                    {% elif dep_rsc.medium.height > 750 %}
                         {% image dep_rsc.id mediaclass="article-depiction-height" class="img-responsive" alt="" crop=dep_rsc.crop_center %}
                    {% else %}
                        {% image dep_rsc.id class="img-auto" alt="" crop=dep_rsc.id.crop_center %}
                    {% endif %}
                    <figcaption>{% if dep_rsc.title %}{{ dep_rsc.title }}{% endif %}</figcaption>
                </figure>
            </a>
        {% else %}
            {% if dep_rsc.is_a.document %}
                {% catinclude "_media_item.tpl" dep_rsc.id %}
            {% else %}
                <a href="{{ dep.id.page_url }}">
                    {% include "_media_item.tpl" dep=dep_rsc %}
                </a>
            {% endif %}
        {% endif %}

    {% endwith %}

{% endif %}

{% endwith %}
{% endwith %}
{% endwith %}