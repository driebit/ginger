{# Action for adding connections between rscs #}

{% block widget_content %}

    {% with objects|default:[] as objects %}
    {% with btn_class|default:"btn btn-small btn-add-thing" as btn_class %}
    {% with m.rsc[category].id as cat_id %}
    {% with new_rsc_title|default:m.rsc[cat_id].title|lower as cat_title %}
    {% with modal_cat_title|default:cat_title as modal_cat_title %}
        <a id="{{ #connect.predicate }}" class="{{ btn_class }}" href="#connect">
            {% if icon %}
                <i class="icon {{ icon }}"></i>
            {% endif %}

            {% if btn_title %}
                {{ btn_title }}
            {% else %}
                + {_ Add: _} {{cat_title }}
            {% endif %}
        </a>
        {% if direction=='in' %}
            {% wire id=#connect.predicate
                action={dialog_open template="_action_ginger_dialog_connect.tpl"
                            title=[_"Add:", " ", modal_cat_title]
                            logon_required
                            object_id=id
                            objects=objects
                            add_author=add_author
                            cat=cat_id
                            tabs_enabled=tabs_enabled
                            callback=callback
                            predicate=predicate
                            direction=direction
                            actions=actions
                            dispatch=dispatch
                            page=page
                            cg_id=cg_id nocatselect nocgselect tab=tab|default:'new'}
            %}
        {% else %}
            {% wire id=#connect.predicate
                action={dialog_open template="_action_ginger_dialog_connect.tpl"
                            title=[_"Add:", " ", modal_cat_title]
                            logon_required
                            subject_id=id
                            objects=objects
                            add_author=add_author
                            cat=cat_id
                            tabs_enabled=tabs_enabled
                            callback=callback
                            predicate=predicate
                            direction=direction
                            actions=actions
                            dispatch=dispatch
                            page=page
                            cg_id=cg_id nocatselect nocgselect tab=tab|default:'new'}
            %}
        {% endif %}
    {% endwith %}
    {% endwith %}
    {% endwith %}
    {% endwith %}
    {% endwith %}

{% endblock %}
