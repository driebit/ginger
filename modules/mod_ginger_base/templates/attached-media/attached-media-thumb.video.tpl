{% if
    id.medium.mime == "text/html-oembed" or
    id.medium.mime == "text/html-video-embed" %}

    {% if id.medium.mime == "text/html-video-embed" %}

        {# embed code used #}

        {% if id.medium.video_embed_service|lower == "youtube" or id.medium.video_embed_service|lower == "vimeo" %}

                {% with id.medium.video_embed_code|replace:["\n", ""]|replace:["^.*src=\"([^\"]+).*$", "\\1"] as embed_code %}

                    <a href="{{ embed_code }}" class="lightbox lightbox-video-embed fancybox.iframe" rel="attached-media" title="">
                        {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
                        <div class="attached-media__caption">{{ id.summary }} {% include "copyrights/copyrights-nolinks.tpl" %}</div>
                    </a>

                {% endwith %}

        {% endif %}

    {% elif id.medium.mime == "text/html-oembed" %}

        {# assume share url used #}

        {% if id.medium.oembed.provider_name|lower == "youtube" %}

            <a href="{{ id.medium.oembed_url|replace:["watch\\?v=","embed/"]|replace:["youtu.be/", "youtube.com/embed/"] }}" class="lightbox lightbox-video-embed fancybox.iframe" rel="attached-media" title="">
                {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
                <div class="attached-media__caption">{{ id.summary }} {% include "copyrights/copyrights-nolinks.tpl" %}</div>
            </a>

        {% elif id.medium.oembed.provider_name|lower == "vimeo" %}

            <a href="https://player.vimeo.com/video/{{ id.medium.oembed.video_id }} " class="lightbox lightbox-video-embed fancybox.iframe" rel="attached-media" title="">
                {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
                <div class="attached-media__caption">{{ id.summary }} {% include "copyrights/copyrights-nolinks.tpl" %}</div>
            </a>

        {% endif %}

    {% endif %}

{% else %}
{# MP4 of rdf #}
    {% if m.rdf[id.rdf] as rdf %}
        {% if rdf.uri|match:".*youtube.*" %}
            <a href="{{ rdf.uri|replace:["watch\\?v=","embed/"]|replace:["youtu.be/", "youtube.com/embed/"] }}" class="lightbox lightbox-video-embed fancybox.iframe" rel="attached-media" title="">
                {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
                <div class="attached-media__caption">{{ rdf.description }} {{ rdf.rights }}</div>
            </a>
        {% else %}
            <a href="{{ rdf.uri }}" class="" rel="attached-media" title="">
                {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
                <div class="attached-media__caption">{{ rdf.description }} {{ rdf.rights }}</div>
            </a>
        {% endif %}
    {% else %}
        <a href="#" data-video-url="/media/attachment/{{ id.medium.filename }}" data-video-width="{{ id.medium.width }}" data-video-height="{{ id.medium.height }}" class="lightbox lightbox-video-embed default-video-player" rel="attached-media" title="">
            {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
            <div class="attached-media__caption">{{ id.summary }} {% include "copyrights/copyrights-nolinks.tpl" %}</div>
        </a>
    {% endif %}
{% endif %}
