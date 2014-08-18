{% extends "ginger_edit_widget_std.tpl" %}

{# Widget for editing connections between rscs #}

{% block widget_title %}{% endblock %}
{% block widget_show_minimized %}false{% endblock %}
{% block widget_id %}sidebar-connections{% endblock %}

{% block widget_content %}

{% with id.category_id as cat_id %}
{% with m.rsc[cat_id].o.viewable_predicates as pred_ids %}

{% for pred_id in pred_ids %}
    {% with m.rsc[pred_id].name as name %}
	    <h4>{{ m.rsc[pred_id].title }}</h4>

		{% if m.rsc[cat_id].name != "collection" and m.rsc[cat_id].name != "query" %}
            <div class="unlink-wrapper">
            {% sorter id=["links",id|format_integer,name]|join:"-" 
                      tag={object_sorter predicate=name id=id} 
                      group=name
                      delegate=`controller_admin_edit`
            %}
            <ul id="links-{{ id }}-{{ name }}" class="tree-list connections-list" data-reload-template="_ginger_edit_list.tpl" style="list-style-type: none; margin-left: 5px; margin-bottom: 0px;">
                {% include "_ginger_edit_list.tpl" id=id predicate=name %}
            </ul>
            </div>
        {% endif %}

	    <p>
		    <a id="{{ #connect.name }}" href="#connect">+ {_ add a connection _}</a>
		   	{% wire id=#connect.name 
		   			action={dialog_open template="_action_ginger_dialog_connect.tpl" 
		   						title=[_"Add a connection: ", p.title]
                                logon_required
                                subject_id=id
                                predicate=name}
		   	%}
	   	</p>

	    <hr />
    {% endwith %}
{% endfor %}

{% endwith %}
{% endwith %}

{% endblock %}
