{% if id.summary %}
    <p class="summary">{{ id.summary }}</p>
{% endif %}

{% with id.depiction.id as first_dep %}
    {% catinclude "media/media.tpl" first_dep %}
{% endwith %}

<div class="body">{{ id.body|show_media }}</div>