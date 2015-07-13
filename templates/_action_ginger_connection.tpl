{# Action for adding connections between rscs #}

{% block widget_content %}

    {% with btn_class|default:"btn btn-small btn-add-thing" as btn_class %}
    {% with m.rsc[category].id as cat_id %}
    {% with	new_rsc_title|default:m.rsc[cat_id].title|lower as cat_title %}
    {% with	modal_cat_title|default:cat_title as modal_cat_title %}

        <a id="{{ #connect.predicate }}" class="{{ btn_class }}" href="#connect">+ {_ add _} {{cat_title }} {_ toe _}</a>
        {% if direction=='in' %}
            {% wire id=#connect.predicate 
                action={dialog_open template="_action_ginger_dialog_connect.tpl" 
                            title=[_"add", " ", modal_cat_title, " ", _"toe "]
                            logon_required
                            object_id=id
                            cat=cat_id
                            findtab=findtab
                            newtab=newtab
                            callback=callback
                            predicate=predicate
                            direction=direction
                            cg_id=cg_id nocatselect nocgselect tab=tab|default:'new'}
            %}
        {% else %}
            {% wire id=#connect.predicate 
                action={dialog_open template="_action_ginger_dialog_connect.tpl" 
                            title=[_"add", " ", modal_cat_title , " ", _"toe"]
                            logon_required
                            subject_id=id
                            cat=cat_id
                            findtab=findtab
                            newtab=newtab
                            callback=callback
                            predicate=predicate
                            direction=direction
                            cg_id=cg_id nocatselect nocgselect tab=tab|default:'new'}
            %}
        {% endif %}


    {% endwith %}
    {% endwith %}
    {% endwith %}
    {% endwith %}

{% endblock %}
