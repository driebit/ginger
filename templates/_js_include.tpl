
{% include "_js_include_jquery.tpl" %}

{% lib
	"js/apps/zotonic-1.0.js"
	"js/apps/z.widgetmanager.js"
	"bootstrap/js/bootstrap.min.js"
%}

{% block _js_extra %}{% endblock %}

<script type="text/javascript">
	$(function()
	{
	    $.widgetManager();
	});
</script>
