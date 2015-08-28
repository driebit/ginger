{% if id.summary %}
    <div class="summary">{{ id.summary }}</div>
{% endif %}

<div class="body">{{ id.body|show_media }}</div>