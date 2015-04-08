{# Action for adding connections between rscs #}

{% block widget_content %}

    {% with	m.rsc[category].id as cat_id %}
    {% with	m.rsc[cat_id].title|lower as cat_title %}
        <a id="{{ #connect.predicate }}" class="btn {{ btn_class }} btn-small btn-add-thing" href="#connect">+ {_ add my  _}  {% if title %} {{ title }} {% else %} {% if new_rsc_title %}{{ new_rsc_title }}{% else %}{{ cat_title|lower }}{% endif %}{% endif %} {_ to this  _}</a>

        {% if direction=='in' %}
            {% wire id=#connect.predicate 
                action={dialog_open template="_action_ginger_dialog_connect.tpl" 
                            title=[_"Add a ", cat_title|lower , _" to ", id.title]
                            logon_required
                            object_id=id
                            cat=cat_id
                            findtab=findtab
                            newtab=newtab
                            predicate=predicate
                            direction=direction}
            %}
        {% else %}
            {% wire id=#connect.predicate 
                action={dialog_open template="_action_ginger_dialog_connect.tpl" 
                            title=[_"Add a ", cat_title , _" to ", id.title]
                            logon_required
                            subject_id=id
                            cat=cat_id
                            findtab=findtab
                            newtab=newtab
                            predicate=predicate
                            direction=direction}
            %}
        {% endif %}


    {% endwith %}
    {% endwith %}

{% endblock %}
