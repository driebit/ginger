<a href="/image/{{ dep_rsc.id.medium.filename }}" class="depiction__image lightbox" rel="fancybox-group"
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
            {% image dep_rsc.id mediaclass="default" class="img-auto" alt="" crop=dep_rsc.id.crop_center %}
        {% endif %}

        <figcaption>{% if dep_rsc.title %}{{ dep_rsc.title }}{% endif %}</figcaption>
    </figure>
</a>


