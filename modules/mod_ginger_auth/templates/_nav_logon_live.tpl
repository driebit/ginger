{#
Render login/register link when user is logged out,
or link to user profile when user is logged in.

Params:
show_picture: whether to show the user’s picture
informal: greet user by on first name basis
greeting: label that greets logged in user
#}

{% with m.rsc[id].uri as page %}
    {% if m.acl.user %}
        <a href="{{ m.rsc[m.acl.user].page_url }}">
            {% if show_picture %}
                {% with m.rsc[m.acl.user].depiction as dep %}
                    {% image dep mediaclass="miniature" %}
                {% endwith %}
            {% endif %}
            {{ greeting }}
            {% if informal and m.rsc[m.acl.user].name_first %}
                {{ m.rsc[m.acl.user].name_first }}
            {% else %}
                {{ m.rsc[m.acl.user].title }}
            {% endif %}
        </a>&nbsp;
        <a href="{% url logoff %}">{{ logoff_label|if_undefined:_"Sign out" }} <i class="glyphicon glyphicon-log-out"></i></a>
    {% else %}
        {% include "_auth_link.tpl" action=action|default:{reload} %}
    {% endif %}
{% endwith %}
