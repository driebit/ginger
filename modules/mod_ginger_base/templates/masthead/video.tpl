{% if dep.oembed.provider_name|lower == "youtube" or dep.video_embed_service|lower == "youtube" %}

    <iframe src="https//www.youtube.com/embed/{{dep.video_embed_id}}?feature=oembed&autoplay=1" frameborder="0" allowfullscreen="allowfullscreen"></iframe>

{% elseif dep.oembed.provider_name|lower == "vimeo" or dep.video_embed_service|lower == "vimeo" %}

    {% if dep.video_embed_id != "" %}
        <iframe src="https://player.vimeo.com/video/{{ dep.video_embed_id }}?autoplay=true" width=\"480\" height=\"270\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\/iframe>
    {% else %}
        <iframe src="https://player.vimeo.com/video/{{ dep.oembed.video_id }}?autoplay=true" width=\"480\" height=\"270\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen><\/iframe>
    {% endif %}

{% endif %}




