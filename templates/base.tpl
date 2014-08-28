<!DOCTYPE html>
<!--[if IE 8 ]> <html lang="{{ z_language|default:"en"|escape }}" class="ie8"> <![endif]-->
<!--[if IE 9 ]> <html lang="{{ z_language|default:"en"|escape }}" class="ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html lang="{{ z_language|default:"en"|escape }}">
<!--<![endif]-->
    <head>
        <script>document.getElementsByTagName('html')[0].className.replace('no-js', 'has-js');</script>
        <!--[if lt IE 9]>
          {% lib
            "js/vendor/html5shiv.js"
            "js/vendor/html5shiv-printshiv.js"
          %}
        <![endif]-->

        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <title>{% block title %}{{ id.title }}{% endblock %} &mdash; {{ m.config.site.title.value }}</title>

        <link rel="icon" href="/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />

        {% lib  
            "css/skeleton.css"
            "css/ginger_site.css"
            "css/zotonic-admin.css"

	        "css/jquery.loadmask.css" 
	        "css/z.growl.css" 
	        "css/z.modal.css" 
        %}
        <!--[if lt IE 10]>
        <link rel="stylesheet" type="text/css" href="/lib/css/build/ie.css">
        <![endif]-->

        {% include "_js_include_jquery.tpl" %}
        {% all include "_head.tpl" %}

        {% block head_extra %}{% endblock %}
    </head>

    <body class="{% block page_class %}{% endblock %}">
    <div class="container">
        <div class="masthead">
            {% block navbar %}
                {% include "_header.tpl" %}
            {% endblock %}
        </div>
        
        {% block content %}{% endblock %}
        
        {% include "_footer.tpl" %}
        {% include "_js.tpl" %}
        {% block _js_include_extra %}{% endblock %}
    </div>
    </body>
</html>
