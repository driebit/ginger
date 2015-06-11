{# A wrapper around the signup/login dialog that displays them in a tabbed view #}

{#{% wire name="ginger_logon_actions" postback={ginger_logon_actions action=action} delegate="ginger_logon" %}#}

<ul class="nav nav-pills">
    {% block tabs %}
    
        <li {% if tab == "logon" %}class="active"{% endif %}>
            {% wire id="#signup" action={replace title="Sign up" target="#dinges" template="_logon_modal.tpl" logon_state=logon } %}
            <a id="{{ #signup }}">{_ Log in _}</a>
        </li>

        <li {% if tab == "signup" %}class="active"{% endif %}>
            {% wire id="#signup" action={show title="Sign up" template="_logon_modal.tpl" logon_state=logon } %}
            <a data-toggle="tab" href="#{{ #tab }}-signup">{_ Sign up _}</a>
        </li>

        <li {% if tab == "forgot" %}class="active"{% endif %}>
            <a data-toggle="tab" href="#{{ #tab }}-forgot">{_ Forgot my password _}</a>
        </li>

	{% endblock %}
</ul>

<div id="dinges"></div>

<div class="tab-content" id="dialog-connect-panels">
    {% block tabs_content %}
    
    

        {% include "_logon_modal.tpl" tab=#tab id=bla logon_state=logon action=action title=""
                    is_active=1 %}

        {% include "_logon_modal.tpl" tab=#tab id=id logon_state=signup action=action title=""
                    is_active=0 %}

        {% include "_action_dialog_forgot.tpl" tab=#tab id=id action=action title=""
                    is_active=0 %}

    {% endblock %}
</div>

