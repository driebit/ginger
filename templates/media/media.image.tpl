<a href="/image/{{ id.medium.filename }}" class="media--image lightbox {{ extraClasses }}" rel="fancybox-group"
{% if id.title %}
    title="{{ id.title }}"
{% elif id.summary %}
    title = "{{ id.summary }}"
{% endif %}
>
    {% block figure %}
        <figure>
            {% if id.medium.width > 750 %}
                {% image id.id mediaclass="article-depiction-width" class="img-responsive" alt="" crop=id.crop_center %}
            {% elif id.medium.height > 750 %}
                 {% image id.id mediaclass="article-depiction-height" class="img-responsive" alt="" crop=id.crop_center %}
            {% else %}
                {% image id.id mediaclass="default" class="img-auto" alt="" crop=id.id.crop_center %}
            {% endif %}
            <figcaption>{% if id.title %}{{ id.title }}{% endif %}</figcaption>
        </figure>
    {% endblock %}
</a>
