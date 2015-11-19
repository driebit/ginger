{# Render link that opens a modal login/signup dialog. #}

{% if zotonic_dispatch == `logon` or zotonic_dispatch == `signup` %}
    {# Do not show logon/signup link on logon and signup pages #}
{% else  %}
        {% live template="_auth_link_live.tpl"
            topic="~pagesession/session"
            target=#auth_link
            action=action|default:{reload}
            show_picture=show_picture
            informal=informal
            greeting=greeting
            icon_before=icon_before
            icon=icon|if_undefined:"glyphicon glyphicon-log-in"
            class=class|default:"login--global-nav"
            label=label|default:_"logon/signup"
            label_class=label_class|default:"main-nav__login-register-button__label"
        %}
{% endif %}
