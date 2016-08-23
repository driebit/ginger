
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    {% include "head/twitter.tpl" %}
    {% include "head/facebook.tpl" %}

    <title>
        {% block title %}
            {% if id %}
                {{ id.seo_title|default:id.title ++ " - " ++ m.config.site.title.value }}
            {% else %}
                {{ m.config.site.title.value }}
            {% endif %}
        {% endblock %}
    </title>

    <meta name="description" content="{% if id.seo_desc %}{{ id.seo_desc }}{% else %}{{ id|summary:160 }}{% endif %}">

    {% if id.seo_keywords %}
        <meta name="keywords" content="{{ id.seo_keywords }}">
    {% endif %}

    {% if id.seo_noindex %}
        <meta name="robots" content="noindex">
    {% endif %}

    <link rel="icon" href="/lib/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="/lib/images/favicon.ico" type="image/x-icon" />

    {% lib
        "bootstrap/css/bootstrap.min.css"
    %}

    {% lib
        "css/z.icons.css"
        "css/logon.css"
    %}

    {% all include "_html_head.tpl" %}
</head>
