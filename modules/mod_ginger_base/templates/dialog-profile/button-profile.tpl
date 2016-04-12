{% if zotonic_dispatch == `logon` or zotonic_dispatch == `signup` or zotonic_dispatch == `logon_reset` %}
    {# Do not show logon/signup link on logon and signup pages #}
{% else  %}
    {% live template="dialog-profile/button-profile-live.tpl"
        topic="~pagesession/session"
        target=#button_profile
        title=title|default:_"Profile"
        class=class|default:"profile--global-nav"
    %}
{% endif %}
