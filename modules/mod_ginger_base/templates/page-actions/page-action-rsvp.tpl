
{% if id.action_rsvp|to_integer|is_defined and id.date_start|in_future %}
    {% with btn_class|default:"page-action--rsvp" as btn_class %}
    {% with id.rsvp_max_participants|to_integer as max_participants %}
    {% with id.s.participant|make_list|length|to_integer as participants %}
    {% with max_participants|is_undefined or participants<max_participants as can_rsvp %}

        {% if m.acl.user %}
            {# If the user is logged in, show its RSVP status #}
            {% with m.acl.user.id, id as user, event %}

                {% if m.edge.id[user].participant[event]|is_defined %}
                    {# User has RSVP'd #}
                    {% button
                        text=_"Cancel RSVP"
                        class=btn_class
                        action={
                            unlink
                            subject_id=user
                            predicate="participant"
                            object_id=event
                            action={
                                redirect
                                id=event
                            }
                        }
                    %}
                {% else %}
                    {# User did not RSVP #}
                    {% if can_rsvp %}
                        {% button
                            text=_"RSVP"
                            class=btn_class
                            action={
                                link
                                subject_id=user
                                predicate="participant"
                                object_id=event
                                action={
                                    redirect
                                    id=event
                                }
                            }
                        %}
                    {% endif %}
                {% endif %}
            {% endwith %}
        {% else %}
            {% if can_rsvp %}
                {# The user is not logged in. Show a dialog for login and RSVP. #}
                {% button
                    text=_"RSVP"
                    class=btn_class
                    action={
                        dialog_open
                        title=_"logon or register"
                        template="_action_dialog_authenticate.tpl"
                        action={dialog_open template="page-actions/page-action-rsvp.tpl" title=_"RSVP" id=id}
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
{% endif %}
