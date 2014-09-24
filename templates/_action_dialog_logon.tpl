<div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-logon">
{%
	wire id="logon_dialog"
	type="submit"
	postback={ginger_logon action=action}
	delegate="ginger_logon"
%}

<div id="logon_error">
    {% include "_logon_error.tpl" reason=error_reason %}
</div>

<div id="logon_form">
    <iframe src="/lib/images/spinner.gif" id="logonTarget" name="logonTarget" style="display:none"></iframe>
    {% with m.rsc[id].uri as page %}
    <form id="logon_dialog" method="post" action="postback" class="z_logon_form" target="logonTarget">
        
        <input type="hidden" name="page" value="{{ page }}" />
        <input type="hidden" name="handler" value="username" />

        <div class="form-group">
            <label for="username" class="control-label">{_ Email _}</label>
            <div class="controls">
            <input type="text" id="username" name="username" value="" class="input-block-level" autofocus="autofocus" autocapitalize="off" autocomplete="on" size="35" style="width: 250px;"/>
            </div>
        </div>

        <div class="form-group">
            <label for="password" class="control-label">{_ Password _}</label>
            <div class="controls">
            <input type="password" id="password" class="input-block-level" name="password" value="" autocomplete="on" size="35" style="width: 250px;"/>
            </div>
        </div>

        <div class="form-group">
            <div>
                <button class="btn btn-primary btn-lg pull-right" type="submit">{_ Log on _}</button>
                <div class="checkbox"><label title="{_ Stay logged on unless I log off. _}">
                    <input type="checkbox" name="rememberme" value="1" />
                    {_ Remember me _}
                </label></div>
            </div>
        </div>

        <div>
            <a class="" href="{% url logon_reminder %}">{_ I forgot my password _}</a>
        </div>
    </form>
    {% endwith %}
</div>    

<ul id="logon_methods">
    {% all include "_logon_extra.tpl" %}
</ul>

{# <a data-toggle="tab" href="#{{ #tab }}-register"><i class="glyphicon glyphicon-log-in">&nbsp;</i>{_ I don’t have an account, please sign me up. _}</a> #}

</div>

{# Use a real post for all forms on this page, and not AJAX or Websockets. This will enforce all cookies to be set correctly. #}
{% javascript %}
z_only_post_forms = true;
{% endjavascript %}

