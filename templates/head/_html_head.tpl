<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta name="author" content="Driebit" />

<title>
    {% if id.seo_title %}
        {{ id.seo_title }}
    {% else %}
        {% block title %}{{ id.title }}{% endblock %} &mdash; {{ m.config.site.title.value }}
    {% endif %}
</title>

{% if id.seo_desc %}
    <meta name="description" content="{{ id.seo_desc }}">
{% endif %}

{% if id.seo_keywords %}
    <meta name="keywords" content="{{ id.seo_keywords }}">
{% endif %}

<link rel="icon" href="/lib/images/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="/lib/images/favicon.ico" type="image/x-icon" />

{% lib
    "bootstrap/css/bootstrap.min.css"
%}

{% lib
    "css/z.icons.css"
%}
