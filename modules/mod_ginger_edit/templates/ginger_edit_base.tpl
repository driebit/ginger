<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta name="author" content="Driebit" />
        <title>{% block title %}{% endblock%}</title>
		<link rel="icon" href="/lib/images/favicon.ico" type="image/x-icon" />
		<link rel="shortcut icon" href="/lib/images/favicon.ico" type="image/x-icon" />

        {% lib
            "bootstrap/css/bootstrap.min.css"
        %}
		{% lib
            "css/ginger-edit.css"
            "css/jquery-ui.datepicker.css"
            "css/jquery.timepicker.css"
            "css/zp-menuedit.css"
            "css/zotonic-admin.css"
            "css/z.icons.css"
            "css/z.modal.css"
            "css/jquery.loadmask.css"
            "css/zotonic-admin.css"
            "css/mod_ginger_edit/screen.css"
        %}

        {% all include "_html_head.tpl" %}
        {% all include "_ginger_html_head_admin.tpl" %}

        {% include "_js_include_jquery.tpl" %}

        <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]>
            <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->

        {% block head_extra %}{% endblock %}
    </head>
	<body class="{% block page_class %}{% endblock %}">
	{% wire name="adminwidget_toggle" action={adminwidget_toggle} %}

    {% block container %}
	<div class="{% block container_class %}container{% endblock %}">
        {% block header %}{% endblock %}

        {% block content %}{% endblock %}

        {% block footer %}{% endblock %}
	</div>
    {% endblock %}

    {% include "_editor.tpl" %}
    {% include "_admin_js_include.tpl" %}
    {% lib
        "js/ginger_edit.js"
    %}
    {% optional include "_ginger_edit_js_extra.tpl" %}


    {% block ua_probe %}
        {% include "_ua_probe.tpl"%}
    {% endblock %}

    {% javascript %}
        $(document).trigger('widgetmanager:loaded');
    {% endjavascript %}

    {% script %}

    </body>
</html>
