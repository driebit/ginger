<!-- {% with id.content_group_id as content_group %}
{% if content_group.o.hassubnav %}

    {% with content_group.o.hassubnav as subnav_ids %}

        <nav class="content-groups__subnav">
             <ul>
                <li><a href="{{ content_group.page_url }}"><i class="fa fa-home"></i>&nbsp; {{ content_group.title }}</a></li>

                {% for subnav_id in subnav_ids %}

                    {% if m.rsc[subnav_id].is_a.collection %}
                        {% for part_id in m.rsc[subnav_id].o.haspart %}
                            <li><a href="{{ m.rsc[part_id].page_url }}">{{ m.rsc[part_id].title }}</a></li>
                        {% endfor %}
                    {% else %}
                         <li><a href="{{ m.rsc[subnav_id].page_url }}">{{ m.rsc[subnav_id].title }}</a></li>
                    {% endif %}
                {% endfor %}
             </ul>
        </nav>
    {% endwith %}
{% endif %}
{% endwith %} -->