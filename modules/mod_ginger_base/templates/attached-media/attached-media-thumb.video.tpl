
{% if
    id.medium.mime == "text/html-oembed" or
    id.medium.mime == "text/html-video-embed" %}

    {% if id.medium.oembed.provider_name|lower == "youtube" %}

        <a href="{{ id.medium.oembed_url|replace:["watch\\?v=","embed/"]|replace:["youtu.be/", "youtube.com/embed/"] }}" class="lightbox lightbox-video-embed fancybox.iframe" rel="attached-media" {% if id.summary %}title="{{ id.summary }}"{% endif %}>
            {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
            <i class="fa fa-play-circle"></i>
        </a>

    {% elif id.medium.video_embed_service|lower == "youtube" %}
 
        {% with id.medium.video_embed_code|replace:["(.*src=\"([^\"]+)\".*)", "\\2"] as embed_code %}

            <a href="{{ embed_code }}" class="lightbox lightbox-video-embed fancybox.iframe" rel="attached-media" {% if id.summary %}title="{{ id.summary }}"{% endif %}>
            {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
            <i class="fa fa-play-circle"></i>
            </a>

        {% endwith %}
    
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


