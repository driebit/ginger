{% for item in items|without_embedded_media:id %}
    {% catinclude "attached-media/attached-media-thumb.tpl" item %}
{% endfor %}
