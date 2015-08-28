<nav class="global-nav do_global_nav">  

    {% block logo %}
        {% include "logo/logo.tpl" class="global-nav__logo" %}
    {% endblock %}

    {% block menu %}
        {% menu id=id %}
    {% endblock %}

    {% block actions %}
        {% include "global-search/toggle-search.tpl" %}
        {% include "toggle-menu/toggle-menu.tpl" %}
        <div class="global-nav__actions cf">
            {% include "_auth_link.tpl" class="login--global-nav" label_class=" " icon="icon--login" icon_before="icon_before" %}
            {% include "dialog-profile/button-profile.tpl" %}
            {% include "dialog-language/button-language.tpl" %}
        </div>
        {% include "global-search/search.tpl" identifier="global-nav" %}
    {% endblock %}
</nav>