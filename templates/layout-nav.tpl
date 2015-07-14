<nav class="layout-nav">
    {% include "global-logo/global-logo.tpl" %}
    
    {% include "global-menu/global-menu.tpl" %}
    
    {% block nav-actions %}
        {% include "login.tpl" %}
        {% include "language.tpl" %}
        {% include "global-search/global-search.tpl" %}
    {% endblock %}
</nav>