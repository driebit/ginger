{% block css %}
    {% lib
        "css/site/screen.css"
        "css/edit-copyrights.css"
    %}
{% endblock %}

{% if id and id.depiction %}
    <meta property="og:image:width" content="200" /> {# Set in mod_facebook/templates/mediaclass.config #}
    <meta property="og:image:height" content="200" />
{% endif %}
