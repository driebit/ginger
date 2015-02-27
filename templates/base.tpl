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
		{#<!--[if lt IE 9]>
		  {% lib
			"js/vendor/html5shiv.js"
			"js/vendor/html5shiv-printshiv.js"
		  %}
		<![endif]-->#}

		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta name="author" content="Driebit" />

		<title>{% block title %}{{ id.title }}{% endblock %} &mdash; {{ m.config.site.title.value }}</title>

		<link rel="icon" href="/lib/images/favicon.ico" type="image/x-icon" />
		<link rel="shortcut icon" href="/lib/images/favicon.ico" type="image/x-icon" /> 

		<script src="//use.typekit.net/byu8yfe.js"></script>
		<script>try{Typekit.load();}catch(e){}</script>
		
		{% all include "_head.tpl" %}
		
		{% lib
			"bootstrap/css/bootstrap.min.css"
			"css/z.icons.css"
		%}

		{% all include "_html_head.tpl" %}
		
		{% block head_extra %}{% endblock %}
	</head>

	<body class="{% block page_class %}{% endblock %}">
	
		<div class="{% block container_class %}container{% endblock %}">
			

			{% block breadcrumb %}{% endblock %}

			{% block content %}{% endblock %}
		
		</div>

		{% include "_js_include.tpl" %}
		{% all include "_script.tpl" %}
        {% block module_script %}{% endblock %}
		{% script %}

	</body>
</html>
