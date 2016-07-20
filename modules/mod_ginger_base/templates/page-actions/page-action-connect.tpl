{% with
    m.acl.user.id,
    can_connect|default:1,
    btn_class|default:"btn btn-default",
    btn_connect_text|default:_"Connect",
    btn_cancel_text|default:_"Disconnect",
    predicate|default:"haspart",
    subject|default:user,
    object|default:id

as
    user,
    can_connect,
    btn_class,
    btn_connect_text,
    btn_cancel_text,
    predicate,
    subject,
    object

 %}
     <div id="page-action-connect" class="page-action-connect">
        {% if user %}
            {# If the user is logged in, show its connect status #}
            {% if m.edge.id[subject][predicate][id]|is_defined %}
                {# User has connected #}
                {% button
                    text=btn_cancel_text
                    class=btn_class++" is-active"
                    action={
                        unlink
                        subject_id=subject
                        predicate=predicate
                        object_id=object
                        action={
                            update
                            template="page-actions/page-action-connect.tpl"
                            target="page-action-connect"
                            subject=subject
                            predicate=predicate
                            object=object
                            id=id
                            btn_connect_text=btn_connect_text
                            btn_cancel_text=btn_cancel_text
                        }
                    }
                %}
            {% else %}
                {% if can_connect %}
                    {# User did not connect #}
                    {% button
                        text=btn_connect_text
                        class=btn_class
                        action={
                            link
                            subject_id=subject
                            predicate=predicate
                            object_id=object
                            action={
                                update
                                template="page-actions/page-action-connect.tpl"
                                target="page-action-connect"
                                subject=subject
                                predicate=predicate
                                object=object
                                id=id
                                btn_connect_text=btn_connect_text
                                btn_cancel_text=btn_cancel_text
                            }
                        }
                    %}
                {% endif %}
            {% endif %}
        {% else %}
            {% if can_connect %}
                {# The user is not logged in. Show a dialog for login and connect. #}
                {% button
                    text=btn_connect_text
                    class=btn_class
                    action={
                        dialog_open
                        title=_"logon or register"
                        template="_action_dialog_authenticate.tpl"
                        action={dialog_open template="page-actions/page-action-connect-user.tpl" title=_" " id=id predicate=predicate btn_connect_text=btn_connect_text btn_cancel_text=btn_cancel_text can_connect=can_connect }
                        tab="logon"
                        id=id
                    }
                %}
            {% endif %}
        {% endif %}
    </div>
{% endwith %}
