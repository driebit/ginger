<div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-register">
{%
	wire id="register_dialog"
	type="submit"
	postback={ginger_register action=action}
	delegate="ginger_logon"
%}

<div id="logon_error">
{% include "_logon_error.tpl" reason=error_reason %}
</div>

<a data-toggle="tab" href="#{{ #tab }}-logon"><i class="glyphicon glyphicon-log-in">&nbsp;</i>{_ I have an account, Log me in. _}</a>

<div id="register_form">
    <iframe src="/lib/images/spinner.gif" id="logonTarget" name="logonTarget" style="display:none"></iframe>
    {% with m.rsc[id].uri as page %}
    <form id="register_dialog" method="post" action="postback" class="z_logon_form" target="logonTarget">
        
        -------
        <input type="hidden" name="page" value="{{ page }}" />

    </form>
    {% endwith %}
</div>    

<ul id="logon_methods">
    {% all include "_logon_extra.tpl" %}
</ul>

</div>

{# Use a real post for all forms on this page, and not AJAX or Websockets. This will enforce all cookies to be set correctly. #}
{% javascript %}
z_only_post_forms = true;
{% endjavascript %}

