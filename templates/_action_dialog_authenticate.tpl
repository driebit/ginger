<ul id="logon_methods" style="text-decoration: none;">
    {% all include "_logon_extra.tpl" %}
</ul>

{% wire name="ginger_logon_actions" postback={ginger_logon_actions action=action} delegate="ginger_logon" %}

<ul class="nav nav-pills">
    {% block tabs %}

        <li {% if tab == "logon" %}class="active"{% endif %}>
            <a data-toggle="tab" href="#{{ #tab }}-logon">{_ Logon _}</a>
        </li>

        <li {% if tab == "signup" %}class="active"{% endif %}>
            <a data-toggle="tab" href="#{{ #tab }}-signup">{_ Signup _}</a>
        </li>

        <li {% if tab == "forgot" %}class="active"{% endif %}>
            <a data-toggle="tab" href="#{{ #tab }}-forgot">{_ Forgot my password _}</a>
        </li>

	{% endblock %}
</ul>

<div class="tab-content" id="dialog-connect-panels">
    {% block tabs_content %}

        {% include "_action_dialog_logon.tpl" tab=#tab id=id action=action title=""
                    is_active=1 %}

        {% include "_action_dialog_signup.tpl" tab=#tab id=id action=action title=""
                    is_active=0 %}

        {% include "_action_dialog_forgot.tpl" tab=#tab id=id action=action title=""
                    is_active=0 %}

    {% endblock %}
</div>

