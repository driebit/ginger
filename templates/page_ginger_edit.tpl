{% extends "base.tpl" %}

{% block title %}{_ Edit _}{% if id %}: {{ id.title|default:"-" }}{% endif %}{% endblock%}

{% block html_head_extra %}
	{% lib 
			"css/admin-frontend.css" 
			"css/jquery-ui.datepicker.css"
            "css/jquery.timepicker.css"
            "css/ginger-edit.css"
	%}
{% endblock %}

{% block content %}
	<div class="row-fluid">
        <div class="span8 main">
            {% include "_ginger_edit.tpl" %}
        </div>
        <div id="subnavbar" class="span4">
            {% block subnavbar %}
                {% catinclude "_aside.tpl" id page="edit" %}
            {% endblock %}
        </div>
	</div>
	{% include "_admin_edit_js.tpl" %}
{% endblock %}

{% block navbar %}
{# The buttons in the navbar click/sync with hidden counter parts in the resource edit form #}
<nav class="navbar">
	<div class="navbar-inner">
	<div class="container-fluid">
		<div class="row-fluid">
			<div class="span8" id="save-buttons" style="display:none">

				{% button class="btn btn-primary" text=_"Save" title=_"Save this page." 
						  action={script script="$('#save_stay').click();"}
				 %}

				{% button class="btn" text=_"Save &amp; view" title=_"Save and view the page." 
						  action={script script="$('#save_view').click();"}
				 %}

				{# button class="btn pull-right" text=_"Cancel" action={redirect back} tag="a" #}
				{#	<a href="{{ id.page_url }}" class="btn">{_ Close _}</a> #}
	    	</div>
		</div>
	</div>
	</div>
</nav>
{% endblock %}

{% block _js_include_extra %}
	{% lib
    	"js/modules/jquery.hotkeys.js"
	    "js/modules/z.tooltip.js"
	    "js/modules/z.feedback.js"
	    "js/modules/z.formreplace.js"
	    "js/modules/z.datepicker.js"
	    "js/modules/z.cropcenter.js"
	    "js/modules/jquery.shorten.js"
	    "js/modules/jquery.timepicker.min.js"

	    "js/apps/admin-common.js"
	    "js/modules/tinymce3.5.0/z_editor.js"
	%}
	{% all include "_admin_lib_js.tpl" %}
	{% include "_admin_tinymce.tpl" is_tinymce_include %}
{% endblock %}
