<nav class="main-nav do_ginger_default_toggle_navigation do_ginger_default_toggle_search">
    <a href="/" class="main-nav__logo"><img src="/lib/images/logo_ginger.png"/></a>

    <div class="main-nav__off-canvas">
        {% menu class="main-nav__pages" %}

        {#
        <ul class="main-nav__actions">
            <li>
                {% optional include "_actions_login.tpl" %}
            </li>
            <li>
                {% optional include "_actions_admin.tpl" %}
            </li>
            <li>
                {% optional include "_actions_profile.tpl" %}
            </li>
        </ul>
        #}
    </div>

    <ul class="main-nav__actions">
        <li class="main-nav__toggle-search"><a href="#main-nav__search-form">Zoek</a></li>
        <li class="main-nav__toggle-menu"><a href="#navigation">Toggle menu</a></li>
    </ul>

    <form id="main-nav__search-form" class="main-nav__search-form" role="search" action="{% url search %}" method="get">
        <input type="hidden" name="qsort" value="{{ q.qsort|escape }}" />
        <input type="hidden" name="qcat" value="{{ q.qcat|escape }}" />
        <input type="text" class="main-nav__search-form__query do_suggestions" name="qs" value="{{q.qs|escape}}" autocomplete="off" placeholder="Zoeken...">
        {% wire name="show_suggestions"
            action={update target="search-suggestions" template="_search_suggestions.tpl"}
        %}

        <button class="main-nav__search-form__close-btn" type="button">Sluiten</button>

        <div id="search-suggestions" class="search-suggestions"></div>
    </form>
</nav>
