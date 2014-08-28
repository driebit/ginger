<span id="nav-logon" style="position: absolute; top: 5px; margin-left:50px">
    {% if m.acl.user %}
        <a href="#" id="{{ #ginger_logoff }}" title="{_ Log Off _}"><i class="icon-off icon-black"></i></a>
        <span class="navbar-text">
            {{ m.rsc[m.acl.user].title }}
        </span>
        {%
            wire id=#ginger_logoff
            postback={ginger_logoff}
            delegate="ginger_logon"
            id=id
            page=m.rsc[id].uri
        %}
    {% else %}
        {% button class="btn" text=_"Log on" action={dialog_open title=_"Log on" width="500" template="_action_dialog_logon.tpl" action={dialog_close} page=m.rsc[id].uri} %}
    {% endif %}
</span>
