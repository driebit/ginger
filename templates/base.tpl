<!DOCTYPE html>
<!--
 #################################
	   _      _      _     _ _
	__| |_ __(_) ___| |__ (_) |_
   / _` | '__| |/ _ \ '_ \| | __|
  | (_| | |  | |  __/ |_) | | |_
   \__,_|_|  |_|\___|_.__/|_|\__|

 ############ driebit ############

 geavanceerde internet applicaties

		 Oudezijds Voorburgwal 247
				 1012 EZ Amsterdam
					020 - 420 8449
				   info@driebit.nl
					www.driebit.nl

##################################
//-->
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
		<meta name="author" content="Driebit" />

		<title>{% block title %}{{ id.title }}{% endblock %} &mdash; {{ m.config.site.title.value }}</title>

		<link rel="icon" href="/lib/images/favicon.ico" type="image/x-icon" />
		<link rel="shortcut icon" href="/lib/images/favicon.ico" type="image/x-icon" />

		{% block customFont %}
			<script src="//use.typekit.net/byu8yfe.js"></script>
			<script>try{Typekit.load();}catch(e){}</script>
		{% endblock %}

		{% all include "_head.tpl" %}

		{% lib
			"bootstrap/css/bootstrap.min.css"
			"css/z.icons.css"
		%}

		{% block siteStyles %}
			<link rel="stylesheet" href="/lib/css/mod_ginger_default/screen.css">
		{% endblock %}

		{% all include "_html_head.tpl" %}

		{% block head_extra %}{% endblock %}
	</head>
    {% with m.rsc[id.content_group_id] as content_group %}
        {% if content_group.o.hassubnav %}
                <body class="{% block page_class %}{% endblock %} has-content-group">
            {% else %}
                <body class="{% block page_class %}{% endblock %}">
            {% endif %}
                    
    		{% block navigation %}
    			{% include "_main-nav.tpl" %}
                {% include "_content-group-nav.tpl" %}
    		{% endblock %}

    		<div class="page__wrapper cf">

    			{% block content %}{% endblock %}

    			{% block footer %}
    				{% include "_footer.tpl" %}
    			{% endblock %}
    		</div>

    		{% include "_js_include.tpl" %}
    		{% all include "_script.tpl" %}
            {% block module_script %}{% endblock %}
    		{% script %}

            {% include "_js_include_jquery.tpl" %}

            {% lib
                    "js/apps/zotonic-1.0.js"
                    "js/apps/z.widgetmanager.js"
                    "js/modules/ubf.js"
                    "js/modules/z.notice.js"
                    "js/modules/z.imageviewer.js"
                    "js/modules/z.dialog.js"
                    "js/modules/livevalidation-1.3.js"
                    "js/modules/z.inputoverlay.js"
                    "js/modules/jquery.loadmask.js"
                    "bootstrap/js/bootstrap.min.js"
                    "js/modules/responsive.js"
                    "js/ginger-search.js"
                    %}

    		{% lib
    			"js/vendor/masonry.js"
    			"js/vendor/imagesloaded.js"
    			"js/src/ginger-default_toggle-navigation.js"
    			"js/src/ginger-default_toggle-search.js"
    			"js/src/ginger-default_correlated-items.js"
    			"js/src/ginger-default_parallax.js"
                "js/src/ginger-default_content-group-navigation.js"
                "js/src/ginger-default_scroll-top.js"
    		%}

            {% block _js_include_extra %}{% endblock %}

    		{#
            <script type="text/javascript">
                $(function()
                {
                    $.widgetManager();
                });
            </script>
    		#}

            {% if m.site.hostname|match:".*\.dev$" %}
        		<!--[if (gt IE 9)|!(IE)]><!-->
        			<script src="//192.168.33.10:35729/livereload.js"></script>
        		<!--<![endif]-->
            {% endif %}
        {% endwith %}
	</body>
</html>
