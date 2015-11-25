{# A wrapper around the signup/login dialog that displays them in a tabbed view

Params:
redirect: URL to redirect to after succesful login
#}

{% lib
    "css/logon.css"
%}

<ul class="nav nav-pills">
    {% block tabs %}
        <li {% if tab == "logon" %}class="active"{% endif %}>
            {% wire id="tab-logon" propagate action={replace target="z_logon_or_signup" template="_logon_modal.tpl" logon_state="logon" page=redirect } %}
            <a data-toggle="tab" id="tab-logon">{_ Log in _}</a>
        </li>

        {% if m.modules.active.mod_signup %}
            <li {% if tab == "signup" %}class="active"{% endif %}>
                {% wire id="tab-signup" propagate action={replace target="z_logon_or_signup" template="_logon_modal.tpl" logon_state="signup" } %}
                <a data-toggle="tab" href="#{{ #tab }}-signup" id="tab-signup">{_ Sign up _}</a>
            </li>
        {% endif %}

        <li {% if tab == "forgot" %}class="active"{% endif %}>
            {% wire id="tab-forgot" propagate action={replace target="z_logon_or_signup" template="_logon_modal.tpl" logon_state="reminder" } %}
            <a data-toggle="tab" href="#{{ #tab }}-forgot" id="tab-forgot">{_ Forgot my password _}</a>
        </li>
	{% endblock %}
</ul>

<div id="tab-content" class="tab-content">
    {% include "_logon_modal.tpl" logon_state=tab page=redirect %}
</div>

{# When the session changes (user logs in), run wire below. The wire will just
   execute any post-logon actions passed to this template as 'action'. #}
{% wire type={mqtt topic="~pagesession/session"} action=action %}
