{% if id %}
    {% if not m.modules.active.mod_facebook %}
        {% if m.config.site.title.value %}
            <meta property="og:site_name" content="{{ m.config.site.title.value }}"/>
        {% endif %}
        {% if id %}
            <meta property="og:title" content="{{ id.title }}"/>
            <meta property="og:description" content="{{ id|summary:160 }}"/>
            <meta property="og:url" content="http://{{ m.site.hostname }}{{ id.page_url }}"/>
            {% if id.depiction %}
                <meta property="og:image" content="http://{{ m.site.hostname }}{% image_url id.depiction mediaclass="facebook-og" %}"/>
            {% endif %}
            
        {% endif %}
    {% endif %}

    {% if id.depiction %}
        <meta property="og:image:width" content="450" /> {# Set in mod_ginger_base/templates/mediaclass.config #}
        <meta property="og:image:height" content="350" />
    {% endif %}
{% endif %}
