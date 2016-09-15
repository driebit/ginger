{% if not m.acl.user %}

    <a class="{{ class }}" id="{{ #signup }}" href="#" title="{{ label }}">
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
            redirect="#reload"
            action=action
        }
    %}

{% endif %}
