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
    {% include "head/head.tpl" id=id %}

	{% with m.rsc[id.content_group_id] as content_group %}

		<body class="{% if content_group %}has-contentgroup {% endif %}{{ id.category.name }} {% block body_class %}{% endblock %} do_foundation do_base">

		{% block global_nav %}
			{% include "global-nav/global-nav.tpl" %}
		{% endblock %}

		{% block content_group_nav %}
			{% include "content-group-nav/content-group-nav.tpl" %}
		{% endblock %}

		{% block content %}{% endblock %}

		{% block footer %}
			{% include "footer/footer.tpl" %}
		{% endblock %}

		{% all include "_js_include.tpl" %}
		{% all include "_script.tpl" %}

        {% javascript %}
            $(document).trigger('widgetmanager:loaded');
        {% endjavascript %}

		{% script %}

        {% block extra_scripts %}{% endblock %}

	{% endwith %}
	</body>
</html>
