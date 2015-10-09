<a href="{% image_url id %}" class="lightbox" rel="attached-media"
    {% if id.summary %}
        title="{{ id.summary }}"
    {% elif id.title %}
        title = "{{ id.title }}"
    {% endif %}
    >
    {% image id mediaclass="media-thumb" class="" title=id.title alt=id.title crop=id.depiction.id.crop_center %}
</a>
