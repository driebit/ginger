<div id="button-logon">
{% if m.acl.user %}
    <div style="font-size: 14px; margin-right:20px; margin-top:1px; padding:4px; background-color: #999999;">
        {{ m.rsc[m.acl.user].title }}
        <a href="#" id="{{ #ginger_logoff }}" title="{_ Log Off _}"><i class="icon-off icon-white"></i></a>
        {%
            wire id=#ginger_logoff
            postback={ginger_logoff}
            delegate="ginger_logon"
            id=id
            page=m.rsc[id].uri
        %}
    </div>
{% else %}
    <div style="font-size: 14px; margin-right:20px; margin-top:-6px;">
        {% button class="btn" text=_"Log on" action={dialog_open title=_"Log on" width="500" template="_action_dialog_logon.tpl" action={dialog_close} page=m.rsc[id].uri} %}
    </div>
{% endif %}
</div>


