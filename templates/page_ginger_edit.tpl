{% extends "ginger_edit_base.tpl" %}

{% block title %}{_ Edit _}{% if id %}: {{ id.title|default:"-" }}{% endif %}{% endblock%}

{% block page_class %}ginger-edit{% endblock %}


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
		<div class="navbar-inner row">
			<div class="col-xs-12" id="save-buttons" style="display:none">
				{% button class="btn ginger-edit-save" text=_"Save" title=_"Save" 
						  action={script script="$('#save_view').click();"}
				 %}

				{% button class="btn pull-right ginger-edit-cancel" text=_"Cancel" action={redirect back} tag="a" %}
				{#	<a href="{{ id.page_url }}" class="btn">{_ Close _}</a> #}

                {% ifnotequal id 1 %}
                    {% button style="float:right;" class="btn btn-default btn-sm" disabled=(r.is_protected or not m.rsc[id].is_deletable) id="delete-button" text=_"Delete" action={dialog_delete_rsc id=id.id on_success={redirect back}} title=_"Delete this page." %}
                {% endifnotequal %}

	    	</div>
		</div>
	</nav>
{% endblock %}
