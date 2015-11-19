{# Render link that opens a modal login/signup dialog. #}

{% if not m.acl.user %}

    {% with
        class|default:"main-nav__login-register-button",
        label_class|default:"main-nav__login-register-button__label",
        icon|if_undefined:"glyphicon glyphicon-log-in",
        icon_before,
        label|default:_"logon/signup",
        action|default:{reload}
    as
        class,
        label_class,
        icon,
        icon_position,
        label,
        action
    %}

    <a class="{{ class }}" id="{{ #signup }}" href="#" title="{_ Login/Registeer _}">
    {% if icon == 'none' %}
        <span class="{{ label_class }}">{{ label }}</span>
    {% elseif icon %}
        {% if icon_before %}
            <i class="{{ icon }}"></i> <span class="{{ label_class }}">{{ label }}</span>
        {% else %}
            <span class="{{ label_class }}">{{ label }}</span> <i class="{{ icon }}"></i>
        {% endif %}
    {% else %}
        <span class="{{ label_class }}">{{ label }}</span>
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
            action=action
        }
    %}

    {% endwith %}
{% endif %}
