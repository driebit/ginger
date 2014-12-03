{% extends "ginger_edit_base.tpl" %}

{% block title %}{_ Edit _}{% if id %}: {{ id.title|default:"-" }}{% endif %}{% endblock%}

{% block head_extra %}
	{% lib 
		"css/mod_ginger_site/screen.css"
        "css/ginger-edit.css"
	%}
{% endblock %}

{% block content %}
    {% if id.is_editable %}
        <div class="row page-ginger_edit_content_row_class">
            <div class="col-sm-8 col-md-8">
                {% catinclude "_ginger_edit.tpl" id %}
            </div>

            <div class="col-sm-4 col-md-4">
                {% catinclude "_aside_ginger_edit.tpl" id page="edit" %}
            </div>
        </div>
        <div class="footer row">
            {% block footer %}{% endblock %}
        </div>
    {% else %}
        <h2>{_ Not allowed _}</h2>
         <a href="/">{_ Go to _} {_ Home _}</a>
    {% endif %}
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

					{% button class="btn pull-right" text=_"Cancel" action={redirect back} tag="a" %}
					{#	<a href="{{ id.page_url }}" class="btn">{_ Close _}</a> #}
		    	</div>
			</div>
		</div>
		</div>
	</nav>
{% endblock %}
