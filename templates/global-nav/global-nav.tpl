{% with m.rsc[id.content_group_id] as content_group %}
{% with content_group!=undefined and content_group.name!="system_content_group" and content_group.name!="default_content_group" as has_cg %}

<nav class="global-nav do_global_nav">  
    {% include "global-nav/global-nav__logo.tpl" %}

    {% menu id=id %}

    {% block nav_actions %}
        <div class="global-nav__actions">
            {% include "_auth_link.tpl" class="global-nav__actions__login" icon_before="1" icon="glyphicon glyphicon-log-in" %}
            {% include "global-nav/global-nav__actions__profile.tpl" %}
            {% include "global-nav/global-nav__actions__language.tpl" %}
            {% include "global-nav/global-nav__actions__search.tpl" %}
            <a href="" class="global-nav__actions__toggle-menu">Menu <i class="icon--menu"></i></a>
        </div>
    {% endblock %}
</nav>

{% endwith %}
{% endwith %}