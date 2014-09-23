{% extends "base.tpl" %}

{% block title %}{_ Edit _}{% if id %}: {{ id.title|default:"-" }}{% endif %}{% endblock%}

{% block head_extra %}
	{% lib 
        "css/zotonic-admin.css" 
        "css/jquery-ui.datepicker.css"
        "css/jquery.timepicker.css"
        "css/ginger-edit.css"
	%}
{% endblock %}

{% block content %}
	<div class="row page-ginger_edit_content_row_class">
        <div class="col-sm-8 col-md-8">
            {% include "_ginger_edit.tpl" %}
        </div>

        <div class="col-sm-4 col-md-4">
            {% catinclude "_aside.tpl" id page="edit" %}
        </div>
	</div>
    <div class="footer row">
        {% block footer %}{% endblock %}
    </div>
{% endblock %}

{% block header %}
	{# The buttons in the navbar click/sync with hidden counter parts in the resource edit form #}
	<nav class="navbar navbar-savebuttons">
		<div class="navbar-inner">
		<div class="container-fluid">
			<div class="row-fluid">
				<div class="col-xs-12" id="save-buttons" style="display:none">

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
	    "js/modules/z.adminwidget.js"
	    "js/modules/z.tooltip.js"
	    "js/modules/z.feedback.js"
	    "js/modules/z.formreplace.js"
	    "js/modules/z.datepicker.js"
	    "js/modules/z.cropcenter.js"
	    "js/modules/jquery.shorten.js"
	    "js/modules/jquery.timepicker.min.js"

	    "js/jquery.ui.nestedSortable.js"

	    "js/apps/admin-common.js"
	%}
	{% all include "_admin_lib_js.tpl" %}

{% endblock %}
