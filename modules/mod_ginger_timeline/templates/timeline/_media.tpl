{% with id.depiction as dep %}
    {% if dep %}
        "media": {
            "caption": "{{ dep.short_title|default:dep.title }}",
            "credit": "",
            "url": "{% image_url dep mediaclass="list-image" alt=id.title class="img-responsive" crop=dep.id.crop_center %}",
            "thumbnail": "{% image_url dep mediaclass="media-thumb" alt=id.title class="img-responsive" crop=dep.id.crop_center %}"
        },
    {% endif %}
{% endwith %}
