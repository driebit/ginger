<div id="nav-logon">
    {% with m.rsc[id].uri as page %}
        {% if m.acl.user %}
            <span>
                {{ m.rsc[m.acl.user].title }}&nbsp;<a href="#" id="{{ #ginger_logoff }}"><i class="glyphicon glyphicon-log-out"></i></a>
            </span>
            {%
                wire id=#ginger_logoff
                postback={ginger_logoff page=page id=id}
                delegate="ginger_logon"
            %}
        {% else %}
            <span>
                <a href="#" id="{{ #ginger_logon }}">{_ logon/register _} <i class="glyphicon glyphicon-log-out"></i></a>
            </span>
            {%
                wire id=#ginger_logon 
                action={dialog_open template="_action_dialog_authenticate.tpl" 
                                title=_"logon or register"
                                template="_action_dialog_authenticate.tpl"
                                action={redirect id=id}
                                id=id
                                tab="logon"}
            %}
        {% endif %}
    {% endwith %}
</div>