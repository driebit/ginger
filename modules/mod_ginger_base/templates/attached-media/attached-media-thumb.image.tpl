<a href="{% image_url id %}" class="lightbox" rel="attached-media"
    {% if id.summary %}title="{{ id.summary }}"{% endif %}>
    {% image id mediaclass="media-thumb" class="" title=id.title|truncate:180 alt=id.title crop=id.depiction.id.crop_center %}
</a>
