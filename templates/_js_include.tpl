{% include "_js_include_jquery.tpl" %}

{% lib
	"js/apps/zotonic-1.0.js"
	"js/apps/z.widgetmanager.js"
	"js/modules/ubf.js"
	"bootstrap/js/bootstrap.min.js"
%}

{% block _js_extra %}{% endblock %}

{% javascript %}
	$.widgetManager();
{% endjavascript %}
