{# Render link that opens a modal login/signup dialog. #}

{% if zotonic_dispatch == `logon` or zotonic_dispatch == `signup` or zotonic_dispatch == `logon_reset` or zotonic_dispatch == `logon_reminder` %}
    {# Do not show logon/signup link on logon and signup pages #}
{% else  %}
    {% live template="_auth_link_live.tpl"
        topic="~pagesession/session"
        target=#auth_link
        action=action|default:{reload}
        icon_before=icon_before
        icon=icon|if_undefined:"glyphicon glyphicon-log-in"
        class=class|default:"login--global-nav"
        label=label|default:(m.modules.active.mod_signup|if:_"logon/signup":_"logon")
        label_class=label_class|default:"main-nav__login-register-button__label"
    %}
{% endif %}
