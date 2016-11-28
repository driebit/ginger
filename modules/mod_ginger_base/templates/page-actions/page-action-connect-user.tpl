{% with m.acl.user.id as user %}
{% with can_connect|default:1 as can_connect %}
{% with btn_class|default:"page-action--add" as btn_class %}
{% with btn_connect_text|default:_"Like" as btn_connect_text %}
{% with btn_cancel_text|default:_"Unlike" as btn_cancel_text %}
{% with predicate|default:"interest" as predicate %}

        {% if user %}
            {# If the user is logged in, show its connect status #}

                {% if m.edge.id[user][predicate][id]|is_defined %}
                    {# User has connected #}
                    {% button
                        text=btn_cancel_text
                        class=btn_class++" is-active"
                        action={
                            unlink
                            subject_id=user
                            predicate=predicate
                            object_id=id
                            action={
                                redirect
                                id=id
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
                                subject_id=user
                                predicate=predicate
                                object_id=id
                                action={
                                    redirect
                                    id=id
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
                        redirect="#reload"
                        action={dialog_open template="page-actions/page-action-connect-user.tpl" title=_" " id=id predicate=predicate btn_connect_text=btn_connect_text btn_cancel_text=btn_cancel_text can_connect=can_connect }
                        tab="logon"
                        id=id
                    }
                %}
            {% endif %}
        {% endif %}

{% endwith %}
{% endwith %}
{% endwith %}
{% endwith %}
{% endwith %}
{% endwith %}

