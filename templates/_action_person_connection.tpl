{# Action for adding connections between rscs #}

{% block widget_content %}
    {% with m.edge.id[subject_id][predicate][object_id] as connection %}
        {% if connection %}

            <a id="{{ #connect.predicate }}" class="btn btn-small btn-primary" href="#connect">{{ unconnect_text }}</a>
            {% wire id=#connect.predicate 
                action={dialog_open template="_action_dialog_person_connect.tpl" 
                            title=connect_text
                            logon_required
                            subject_id=subject_id
                            predicate=predicate
                            object_id=object_id
                            unconnect_text=unconnect_text
                            connect_question=connect_question}
            %}

        {% else %}

            <a id="{{ #connect.predicate }}" class="btn btn-small" href="#connect">{{ connect_text }}</a>
            {% wire id=#connect.predicate 
                action={dialog_open template="_action_dialog_person_connect.tpl" 
                            title=connect_text
                            logon_required
                            subject_id=subject_id
                            predicate=predicate
                            object_id=object_id
                            connect_question=connect_question}
            %}

        {% endif %}
    {% endwith %}

{% endblock %}
