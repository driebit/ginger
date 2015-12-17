<nav class="global-nav do_global_nav">

    {% block logo %}
        {% include "logo/logo.tpl" class="global-nav__logo" %}
    {% endblock %}

    {% block menu %}
        {% menu id=id %}
    {% endblock %}

    {% block actions %}
        {% include "global-nav/global-nav-actions.tpl" %}
    {% endblock %}
</nav>
