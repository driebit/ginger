<nav class="global-nav do_global_nav">  
    {% include "global-nav/global-nav__logo.tpl" %}

    {% block nav_actions %}
        <div class="global-nav__actions cf">
            {% include "_auth_link.tpl" class="login--global-nav" icon="none" %}
            {% include "global-nav/global-nav__actions__profile.tpl" %}
            {% include "global-nav/global-nav__actions__profile.tpl" %}
            {% include "global-nav/global-nav__actions__language.tpl" %}
            {% include "global-nav/global-nav__actions__search.tpl" %}
            <a href="" id="global-nav__toggle-menu" class="global-nav__actions__toggle-menu">Menu</a>
        </div>
    {% endblock %}

    {% menu id=id %}
</nav>