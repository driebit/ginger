{# Render link that opens a modal login/signup dialog. #}

{% if not m.acl.user %}

    {% with
        class|default:"main-nav__login-register-button",
        icon|if_undefined:"glyphicon glyphicon-log-in",
        icon_before,
        label|default:_"logon/signup"
    as
        class,
        icon,
        icon_position,
        label
    %}

    {% lib
        "css/logon.css"
    %}

    <a class="{{ class }}" id="{{ #signup }}" href="#">
    {% if icon %}
        {% if icon_before %}
            <span class="{{ icon }}"></span> {{ label }}
        {% else %}
            {{ label }}<span class="{{ icon }}"></span>
        {% endif %}
    {% else %}
        {{ label }}
    {% endif %}
    </a>

    {% wire
        id=#signup
        action={
            dialog_open
            title=title|default:_"Log in or sign up"
            template=dialog_template|default:"_action_dialog_authenticate.tpl"
            tab=tab|default:"logon"
            redirect=m.req.path
        }
    %}

    {% endwith %}
{% endif %}
