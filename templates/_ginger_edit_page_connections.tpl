{# Widget for editing connections between rscs #}

{% block widget_content %}

{% with id.category_id as cat_id %}
{% with m.rsc[cat_id].o.viewable_predicates as pred_ids %}

{% for pred_id in pred_ids %}
    {% with m.rsc[pred_id].name as name %}

        <h4 class="section-title">{{ m.rsc[pred_id].title }}</h4>

	    <div style="margin-top:0px; padding: 5px;">
            {% with	m.predicate.object_category[name]|first|element:1 as cat_id %}
                {# TODO choice of all possible categories? loop m.predicate.object_category[name] #}
                <a id="{{ #connect.name }}" href="#connect">+ {_ add a  _} {{ m.rsc[cat_id].title}}</a>
            {% endwith %}

		   	{% wire id=#connect.name 
		   			action={dialog_open template="_action_ginger_dialog_connect.tpl" 
		   						title=[_"Add a connection: ", p.title]
                                logon_required
                                subject_id=id
                                predicate=name}
		   	%}
	   	</div>

		{% if m.rsc[cat_id].name != "collection" and m.rsc[cat_id].name != "query" %}
            <div class="list-group row">
            <div class="unlink-wrapper">
                {% sorter id=["links",id|format_integer,name]|join:"-" 
                          tag={object_sorter predicate=name id=id} 
                          group=name
                          delegate=`controller_admin_edit`
                %}
                <div id="links-{{ id }}-{{ name }}" class="tree-list connections-list" data-reload-template="_ginger_edit_list.tpl">
                    {% for o_id, edge_id in m.edge.o[id][name] %}
                        {% catinclude "_ginger_edit_list_item.tpl" o_id class="col-xs-12" subject_id=id predicate=name object_id=o_id edge_id=edge_id editable%}
                    {% endfor %}
                </div>
            </div>
            </div>
        {% endif %}

    {% endwith %}
{% endfor %}

{% endwith %}
{% endwith %}

{% endblock %}
