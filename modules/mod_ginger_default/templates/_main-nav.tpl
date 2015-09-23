<nav class="main-nav do_ginger_default_toggle_navigation do_ginger_default_toggle_search">
    {% block mainNavLogo %}
        <a href="/" class="main-nav__logo">
            <img src="/lib/images/logo.png" alt=""/>
        </a>
    {% endblock %}

    <div class="main-nav__off-canvas">

        {% block mainNavActions %}
            <ul class="main-nav__actions clearfix">
                <li>
                    {% optional include "_nav_logon.tpl" %}
                </li>

                {#
                <li>
                    {% optional include "_nav_admin.tpl" %}
                </li>
                #}

                {% with m.rsc[id].uri as page %}
                {% if m.acl.user %}

                     <li>
                        <a href="#" id="{{ #ginger_logoff }}">
                            {# <i class="navicon-logout"></i>  #}

                            <i class="navicon-logout">&nbsp;</i>

                            {_ Log out _}
                        </a>
                        {% wire
                            id=#ginger_logoff
                            postback={ginger_logoff page=page id=id}
                            delegate="ginger_logon"
                        %}
                    </li>

                {% endif %}
                {% endwith %}

                <li class="main-nav__actions__language">
                    {% with m.translation.language_list_enabled as languages %}
                        {% if languages and languages[2]%}
                            {% for code,lang in languages %}
                                {% if all or lang.is_enabled %}
                                    <a class="{% if z_language == code %}active{% endif %}" href="{% url language_select code=code p=m.req.raw_path %}">
                                        <span>{{ code | upper }}</span>
                                    </a>
                                {% endif %}
                            {% endfor %}
                        {% endif %}
                    {% endwith %}
                </li>
            </ul>
        {% endblock %}

        {% menu class="main-nav__pages" %}

    </div>

    <ul class="main-nav__actions">
        <li class="main-nav__toggle-search"><a href="#main-nav__search-form">Zoek</a></li>
        <li class="main-nav__toggle-menu"><a href="#navigation">Toggle menu</a></li>
    </ul>

    <div class="main-nav__search">
        {% include "_search_form.tpl" identifier="main-nav" %}
        <button class="main-nav__search__close-btn" type="button">Sluiten</button>
    </div>
</nav>

{% block contentgroupNav %}{% endblock %}