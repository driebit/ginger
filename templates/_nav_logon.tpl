<div id="nav-logon">
    {% with m.rsc[id].uri as page %}    
        {% if m.acl.user %}
            <span>
                {{ m.rsc[m.acl.user].title }}&nbsp;<a href="#" id="{{ #ginger_logoff }}" class="btn btn-default" title="{_ Log Off _}"><i class="glyphicon glyphicon-off"></i></a>
            </span>
            {%
                wire id=#ginger_logoff
                postback={ginger_logoff page=page id=id}
                delegate="ginger_logon"
            %}
        {% else %}
            {% button class="btn btn-default" text=_"Log on" action={dialog_open title=_"Log on" template="_action_dialog_logon.tpl" action={redirect id=id} id=id} %}
        {% endif %}
    {% endwith %}
</div>