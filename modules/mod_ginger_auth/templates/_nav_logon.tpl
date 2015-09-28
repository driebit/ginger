<div id="nav-logon" class="nav-logon">
{% if zotonic_dispatch == `logon` or zotonic_dispatch == `signup` %}
    {# Don't show logon/signup link on logon and signup pages #}
{% else %}
    {% live template="_nav_logon_live.tpl"
        topic="~pagesession/session"
        target="nav-logon"
        id=id
        action=action
        show_picture=show_picture
        informal=informal
        greeting=greeting
    %}

    {% javascript %}
        pubzub.subscribe("~pagesession/session", function (state) {
            z_event("ginger_post_logon");
        });
    {% endjavascript %}

{% endif %}
</div>
