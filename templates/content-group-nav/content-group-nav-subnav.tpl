{% if content_group.o.hassubnav %}
    {% with content_group.o.hassubnav as subnav_ids %}
    <nav class="content-group-nav__menu">
         <ul>
            <li>
                <a href="{{ content_group.page_url }}" class="
                {% if id == content_group.id %} active {% endif %}
                "><i class="icon--home"></i>&nbsp; {% if content_group.short_title %}{{ content_group.short_title }}{% else %}{{ content_group.title }}{% endif %}</a></li>
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