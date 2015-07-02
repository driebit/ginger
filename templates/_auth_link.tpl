{# Render link that opens a modal login/signup dialog. #}

{% if not m.acl.user %}
    {% lib
        "css/logon.css"
    %}

    <a id="{{ #signup }}" href="#">{{ label|default:_"logon/signup" }} <i class="glyphicon glyphicon-log-in"></i></a>
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
{% endif %}
