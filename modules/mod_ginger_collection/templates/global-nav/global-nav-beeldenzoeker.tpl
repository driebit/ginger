<nav class="global-nav do_global_nav">
    <div class="global-nav__left">
        {% block logo %}
            <a href="{% url collection_home %}" class="global-nav__left__logo">{_ Museum collection _}</a>
        {% endblock %}
        <a href="{% url collection_home %}" class="global-nav__left__home"><i class="icon--home"></i> Home</a>
        {% block extra_logos %}{% endblock %}
    </div>

    {% block menu %}
        {% menu menu_id=m.rsc.beeldenzoeker_menu.id id=id %}
    {% endblock %}

    {% block actions %}
        {% include "search-suggestions/toggle-search.tpl" %}
        {% include "toggle-menu/toggle-menu.tpl" %}
        <div class="global-nav__actions cf">
            {% optional include "_auth_link.tpl" class="login--global-nav" label_class=" " icon="icon--person" icon_before %}
            {% include "dialog-profile/button-profile.tpl" %}
            {% include "dialog-language/button-language.tpl" raw_path=m.req.raw_path %}
        </div>
        {% include "search-suggestions/search.tpl" identifier="global-nav" %}
    {% endblock %}
</nav>
