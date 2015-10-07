<div class="">
    <a href="{% image_url id %}" class="lightbox" rel="attached-media-group" 
        {% if id.summary %}
            title="{{ id.summary }}"
        {% elif id.title %}
            title = "{{ id.title }}"
        {% endif %}
        >
        {% image id mediaclass="attached-media" class="" title=id.title alt=id.title crop=id.depiction.id.crop_center %}
    </a>
</div>