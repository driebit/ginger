{# Action for adding connections between rscs #}

{% block widget_content %}

    {% with m.rsc[category].id as cat_id %}
    {% with new_rsc_title|default:m.rsc[cat_id].title|lower as cat_title %}
        <a id="{{ #connect.predicate }}" class="ginger-btn-pill--primary" href="#connect">+ {_ add my  _} {{cat_title }} {_  to this  _}</a>

        {% if direction=='in' %}
            {% wire id=#connect.predicate 
                action={dialog_open template="_action_ginger_dialog_connect.tpl" 
                            title=[_"Add a ", cat_title , _"  to  ", id.title]
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
                            title=[_"Add a ", cat_title , _"  to  ", id.title]
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

{% endblock %}
