{% if id.depiction %}
    <meta name="twitter:card" content="summary_large_image">
{% else %}
    <meta name="twitter:card" content="summary">
{% endif %}
{% if m.config.site.title.value %}
    <meta name="twitter:site" content="{{ m.config.site.title.value }}">
{% endif %}
{% if id %}
    <meta name="twitter:title" content="{{ id.title }}">
    <meta name="twitter:description" content="{{ id|summary:135 }}">
	{% if id.depiction %}
        <meta name="twitter:image" content="http://{{ m.site.hostname }}{% image_url id.depiction mediaclass="facebook-og" %}">
    {% endif %}
{% endif %}
