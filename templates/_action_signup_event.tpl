{% if id %}
    {# Show an RSVP button, for events only #}

    {% if id.category_id.name == m.rsc.event.name %}
        {# if logged in show RSVP status #}

        {% if m.acl.user %}
            {% with m.acl.user.id, id as user, event %}
                {% if m.edge.id[user].participant[event]|is_defined %}
                    {# User has RSVPd #}
                    {% button
                        text=_"Afmelden"
                        class="ginger-btn-pill--primary"
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
                    {% button
                        text=_"Aanmelden"
                        class="ginger-btn-pill--primary"
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
            {% endwith %}
        {% else %}
            {# The user is not logged in. Clicking on RSVP only logs in, nothing else. #}
            {% button
                text=_"Aanmelden"
                class="ginger-btn-pill--primary"
                action={
                    dialog_open
                    title=_"logon or register"
                    template="_action_dialog_authenticate.tpl"
                    action={redirect id=id}
                    tab="logon"
                    id=id
                }
            %}
        {% endif %}
    {% endif %}
{% endif %}