{% if
    id.medium.mime == "text/html-oembed" or
    id.medium.mime == "text/html-video-embed" and
    id.medium.oembed_url %}

    {% if id.medium.oembed.provider_name|lower == "youtube" %}

        <a href="{{ id.medium.oembed_url|replace:["https://youtu.be/","http://www.youtube.com/embed/"] }}" class="lightbox lightbox-video-embed fancybox.iframe" rel="attached-media" {% if id.summary %}title="{{ id.summary }}"{% endif %}>
            {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
            <i class="fa fa-play-circle"></i>
        </a>

    {% elif id.medium.oembed.provider_name|lower == "vimeo" %}

        <a href="https://player.vimeo.com/video/{{ id.medium.oembed.video_id }} " class="lightbox lightbox-video-embed fancybox.iframe" rel="attached-media" {% if id.summary %}title="{{ id.summary }}"{% endif %}>
        {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
            <i class="fa fa-play-circle"></i>
        </a>

    {% endif %}

{% else %}

    <a href="{{ id.page_url }}" class="lightbox" rel="attached-media" {% if id.summary %}title="{{ id.summary }}"{% endif %}>
        {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
    </a>

{% endif %}


