<div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-forgot">
{%
	wire id="ginger_password_reminder"
	type="submit"
	postback={ginger_reminder action=action}
	delegate="ginger_logon"
%}

    <div id="reminder_error">
        {% include "_logon_error.tpl" reason=error_reason %}
    </div>

    <div id="reminder_form">
    <form id="ginger_password_reminder" method="post" action="postback" class="clearfix">

        <p>{_ Enter your e-mail address or username below and we will send you an e-mail with password reset instructions. _}</p>

        <div class="form-group">
            <label for="reminder_address" class="control-label">{_ E-mail address or username _}</label>
            <div class="controls">

            <input class="input-block-level" type="text" id="reminder_address"
                       autofocus="autofocus"
                       autocapitalize="off"
                       size="35" style="width: 250px;"
                       placeholder="{_ user@example.com _}"
                       name="reminder_address"
                       value="{{ q.username|default:(m.identity[m.acl.user].username)|escape }}"
                       autocapitalize="off"
                       autocomplete="on" />
                {% validate id="reminder_address" type={presence} %}
            </div>
        </div>

        <div class="form-group buttons pull-right">
            <button class="btn btn-primary" type="submit">{_ Send me instructions _}</button>
        </div>

    </form>
    </div>
</div>
