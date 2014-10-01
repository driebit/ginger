{# Widget for editing connections between rscs #}

{% block widget_content %}


    {% with id.category_id as cat_id %}
    {% with m.rsc[cat_id].o.viewable_predicates as pred_ids %}

    {% for pred_id in pred_ids %}
        {% with m.rsc[pred_id].name as name %}

            <h4 class="section-title">{{ m.rsc[pred_id].title }}</h4>
            <p>{_ You can add your own story _}</p>
    	    
            <div>
                {% with	m.predicate.subject_category[name]|first|element:1 as subj_cat_id %}
                    {% with	m.rsc[subj_cat_id].title as subj_cat_title %}
                        {# TODO choice of all possible categories? loop m.predicate.object_category[name] #}
                        <a id="{{ #connect.name }}" class="btn btn-small btn-add-story" href="#connect">+ {_ add my  _} {{ subj_cat_title|lower }} {_ to this  _}</a>

                        {% wire id=#connect.name 
                                action={dialog_open template="_action_ginger_dialog_connect.tpl" 
                                            title=[_"Add a ", subj_cat_title|lower , _" to ", id.title]
                                            logon_required
                                            object_id=id
                                            predicate=name}
                        %}
                    {% endwith %}
                {% endwith %}
    	   	</div>

    		{% if m.rsc[cat_id].name != "collection" and m.rsc[cat_id].name != "query" %}
                <div class="list-group row">
                    {# /rsc/325/s/about #}
                    {% live template="_ginger_edit_page_connections_list.tpl" 
                        topic="/rsc/"|append:id|append:"/s/"|append:name 
                        id=id name=name 
                     %}
                </div>
            {% endif %}

        {% endwith %}
    {% endfor %}

    {% endwith %}
    {% endwith %}

{% endblock %}
