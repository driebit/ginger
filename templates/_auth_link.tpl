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

    <a class="{{ class }}" id="{{ #signup }}" href="#" title="{_ Login/Registeer _}">
    {% if icon == 'none' %}
        <span class="main-nav__login-register-button__label">{{ label }}</span>
    {% elseif icon %}
        {% if icon_before %}
            <i class="{{ icon }}"></i> <span class="main-nav__login-register-button__label">{{ label }}</span>
        {% else %}
            <span class="main-nav__login-register-button__label">{{ label }}</span> <i class="{{ icon }}"></i> 
        {% endif %}
    {% else %}
        <span class="main-nav__login-register-button__label">{{ label }}</span>
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
