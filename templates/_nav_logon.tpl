<div class="navbar-right" style="margin-top: -8px;">
    <ul class="nav navbar-nav">
    {% if m.acl.user %}
        <span class="navbar-text">
            {{ m.rsc[m.acl.user].title }}&nbsp;<a href="#" id="{{ #ginger_logoff }}" class="btn btn-default" title="{_ Log Off _}"><i class="glyphicon glyphicon-off"></i></a>
        </span>
        {%
            wire id=#ginger_logoff
            postback={ginger_logoff}
            delegate="ginger_logon"
            id=id
            page=m.rsc[id].uri
        %}
    {% else %}
        {% button class="btn btn-default" text=_"Log on" action={dialog_open title=_"Log on" width="500" template="_action_dialog_logon.tpl" action={dialog_close} page=m.rsc[id].uri} %}
    {% endif %}
    </ul>
</div>
