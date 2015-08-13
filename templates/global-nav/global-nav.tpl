<nav class="global-nav do_global_nav">  

    {% block logo %}
        {% include "logo/logo.tpl" class="global-nav__logo" %}
    {% endblock %}

    {% block nav_actions %}
        <div class="global-nav__actions cf">
            {% include "_auth_link.tpl" class="login--global-nav" icon="none" %}
            {% include "dialog-profile/button-profile.tpl" %}
            {% include "dialog-language/button-language.tpl" %}
            {% include "global-search/search.tpl" identifier="global-nav" %}
            {% include "toggle-menu/toggle-menu.tpl" %}
        </div>
    {% endblock %}

    {% block menu %}
        {% menu id=id %}
    {% endblock %}

</nav>