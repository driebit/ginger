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
                action={dialog_open template="_action_dialog_logon.tpl" 
                                title=_"Log on"
                                template="_action_dialog_logon.tpl"
                                action={redirect id=id}
                                id=id}
            %}
        {% endif %}
    {% endwith %}
</div>