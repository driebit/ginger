{% if id.medium.oembed.provider_name|lower != "youtube" and id.medium.oembed.provider_name|lower != "vimeo" and id.rights != 'CR' %}
    <a href="/media/attachment/{{ id.medium.filename }}" class="btn--secondary">{_ download _}</a>
{% endif %}
