{% lib "css/logon.css" %}

<ul class="nav nav-pills">
    {% block tabs %}

        <li {% if tab == "logon" %}class="active"{% endif %}>
            <a data-toggle="tab" href="#{{ #tab }}-logon">{_ Logon _}</a>
        </li>

        <li {% if tab == "register" %}class="active"{% endif %}>
            <a data-toggle="tab" href="#{{ #tab }}-register">{_ Register _}</a>
        </li>

	{% endblock %}
</ul>

<div class="tab-content" id="dialog-connect-panels">
    {% block tabs_content %}

        {% include "_action_dialog_logon.tpl" tab=#tab id=id action=action title=""
                    is_active=1 %}

        {% include "_action_dialog_register.tpl" tab=#tab id=id action=action title=""
                    is_active=0 %}

    {% endblock %}
</div>

