
{% if id.medium.oembed.provider_name|lower != "youtube" and id.medium.oembed.provider_name|lower != "vimeo" %}
    <a class="media-download" href="/media/attachment/{{ id.medium.filename }}">download</a>
{% endif %}

