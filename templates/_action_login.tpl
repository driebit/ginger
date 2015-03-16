{% with m.rsc[id].uri as page %}
    {% if m.acl.user %}
        <button id="{{ #ginger_logoff }}" class="button btn-logout">
            {_ Log uit _}
        </button>
        {% wire
            id=#ginger_logoff
            postback={ginger_logoff page=page id=id}
            delegate="ginger_logon"
        %}
    {% else %}
        <button id="{{ #ginger_logon }}" class="button btn-login">
            {_ Log in _}
        </button>
        {% wire
            id=#ginger_logon
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
{% endwith %}
