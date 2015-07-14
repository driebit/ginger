<nav class="global-nav">  
    {% include "global-logo/global-nav_logo.tpl" %}
    
    {% include "global-menu/global-nav_menu.tpl" %}
    
    {% block nav_actions %}
        <div class="global-nav__actions">
            {% include "login.tpl" %}
            {% include "language.tpl" %}
            {% include "global-nav_search.tpl" %}
        </div>
    {% endblock %}
</nav>