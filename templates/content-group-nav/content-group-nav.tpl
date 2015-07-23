
{% with m.rsc[id.content_group_id] as content_group %}
{% with content_group!=undefined and content_group.name!="system_content_group" and content_group.name!="default_content_group" as has_cg %}

{% if has_cg %}

    <div class="content-group-nav do_content_group_nav">

        {% if content_group.o.hasbanner %}
            {% with content_group.o.hasbanner.depiction as banner_dep %}
            <a href="#" class="content-group-nav__banner">
                <div class="content-group-nav__banner__bg" style="background-image: url('{% image_url banner_dep mediaclass='content-group-banner' %}');"></div> 
                <h1 class="content-group-nav__banner__title">{% if content_group.short_title %}{{ content_group.short_title }}{% else %}{{ content_group.title }}{% endif %}</h1>
            </a>
            {% endwith %}
        {% endif %}

        {% if content_group.o.hassubnav %}
            {% with content_group.o.hassubnav as subnav_ids %}
            <nav class="content-group-nav__menu">
                 <ul>
                    <li>
                        <a href="{{ content_group.page_url }}" class="
                        {% if id == content_group.id %} active {% endif %}
                        "><i class="content-group-nav__menu__home"></i>&nbsp; {% if content_group.short_title %}{{ content_group.short_title }}{% else %}{{ content_group.title }}{% endif %}</a></li>
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

    </div>

{% endif %}

{% endwith %}
{% endwith %}