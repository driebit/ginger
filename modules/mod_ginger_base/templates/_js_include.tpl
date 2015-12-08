{#
    Override mod_base/templates/_js_include.tpl to have a good base set of JS
    includes from both mod_base and mod_mqtt.
#}

{% include "_js_include_jquery.tpl" %}

{% lib
    "js/apps/zotonic-1.0.js"
    "js/apps/z.widgetmanager.js"
    "js/modules/ubf.js"
    "js/modules/z.notice.js"
    "js/modules/z.imageviewer.js"
    "js/modules/z.dialog.js"
    "js/modules/livevalidation-1.3.js"
    "js/modules/jquery.loadmask.js"
    "js/qlobber.js"
    "js/pubzub.js"
    "js/modules/z.live.js"
    "js/modules/z.feedback.js"
    "js/modules/z.popupwindow.js"
%}

{% block _js_include_extra %}{% endblock %}

<script type="text/javascript">
	$(function()
	{
	    $.widgetManager();
	});
</script>
