<div class="mod_ginger_nav do_mod_ginger_nav">

    <nav class="mod_ginger_nav__main-nav">

        {% block mainNavLogo %}
        {% endblock %}

        <a href="#" class="mod_ginger_nav__top-button mod_ginger_nav__main-nav__search-button">
            <span class="glyphicon glyphicon-search">&nbsp;</span>
        </a>

        {% block extrabuttons %}{% endblock %}

        {% block logon %}
            {% include "_nav_logon.tpl" %}
        {% endblock %}

        <a href="#" class="mod_ginger_nav__top-button mod_ginger_nav__main-nav__toggle-menu">
            <span class="glyphicon glyphicon-menu-hamburger">&nbsp;</span>
        </a>

        <div class="mod_ginger_nav__main-nav__container hidden">
            {% menu id=id class="mod_ginger_nav__main-nav__container__menu" %}
        </div>

        {% include "_search_form.tpl" identifier="am" extraClasses="" %}

    </nav>

    {% with m.rsc[id.content_group_id] as content_group %}
        {% if content_group and content_group.name != "system_content_group" and content_group.name != "default_content_group" %}
                {% if content_group.o.hasbanner %}
                    {% with content_group.o.hasbanner.depiction as banner_dep %}
                      <a href="#" class="mod_ginger_nav__theme-banner" style="background-image: url('{% image_url banner_dep mediaclass='theme-banner' %}');">
                        <h1 class="mod_ginger_nav__theme-banner__title">{% if content_group.short_title %}{{ content_group.short_title }}{% else %}{{ content_group.title }}{% endif %}</h1>
                      </a>
                    {% endwith %}
                {% endif %}
                {% if content_group.o.hassubnav %}
                    {% with content_group.o.hassubnav as subnav_ids %}
                        <nav class="mod_ginger_nav__theme-menu">
                             <ul>
                                <li>
                                    <a href="{{ content_group.page_url }}" class="
                                    {% if id == content_group.id %} active {% endif %}
                                    "><i class="fa fa-home"></i>&nbsp; {% if content_group.short_title %}{{ content_group.short_title }}{% else %}{{ content_group.title }}{% endif %}</a></li>
                                    }
                                {% for subnav_id in subnav_ids %}
                                    {% if m.rsc[subnav_id].is_a.collection %}
                                        {% for part_id in m.rsc[subnav_id].o.haspart %}
                                            <li><a class="{% if id == part_id %} active {% endif %}" href="{{ m.rsc[part_id].page_url }}">
                                            {% if m.rsc[part_id].short_title %}{{ m.rsc[part_id].short_title }}{% else %}{{ m.rsc[part_id].title }}{% endif %}
                                            </a></li>
                                        {% endfor %}
                                    {% else %}                   
                                         <li><a class="{% if id == subnav_id %} active {% endif %}" href="{{ m.rsc[subnav_id].page_url }}">
                                        {% if m.rsc[subnav_id].short_title %}{{ m.rsc[subnav_id].short_title }}{% else %}{{ m.rsc[subnav_id].title }}{% endif %}
                                         </a></li>
                                    {% endif %}
                                {% endfor %}
                             </ul>
                        </nav>
                    {% endwith %}
                {% endif %}
        {% endif %}
    {% endwith %}
    
</div>