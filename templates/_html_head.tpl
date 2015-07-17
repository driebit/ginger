        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="author" content="Driebit" />

        <title>{% block title %}{{ id.title }}{% endblock %} &mdash; {{ m.config.site.title.value }}</title>

        <link rel="icon" href="/lib/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" href="/lib/images/favicon.ico" type="image/x-icon" /> 

        {% lib 
            "bootstrap/css/bootstrap.min.css"
        %}

        {% lib 
            "css/z.icons.css"
        %}