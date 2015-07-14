{% if menu %}
{% with id|menu_trail:menu_id as parents %}
    <ul id="{{ id_prefix }}navigation" class="{{ class }}">
    {% for mid, path, action in menu %}
        {% if mid %}

            {% if mid.is_a.collection and mid.o.haspart %}
                <li class="dropdown{% if mid|member:parents %} active{% endif %}">
                    <a href="{% if context %}/{{ context }}/{{ mid.id }}{%else %}{{ mid.page_url }}{% endif %}" class="dropdown-toggle disabled {{ mid.name }}" data-hover="dropdown" data-toggle="dropdown" data-target="#">
                        {{ mid.short_title|default:mid.title }} <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                        {% for pid in mid.o.haspart %}
                            {% if pid.is_visible %}
                                <li class="">
                                    <a href="{% if context %}/{{ context }}/{{ pid.id }}{%else %}{{ pid.page_url }}{% endif %}" class="{{ pid.name }}" data-target="#">
                                        {{ pid.short_title|default:pid.title }}
                                    </a>
                                </li>
                            {% endif %}
                        {% endfor %}
                    </ul>
            {% elif action==`down` %}
                <li class="dropdown{% if mid|member:parents %} active{% endif %}">
                    <a href="{{ mid.page_url }}" class="dropdown-toggle disabled {{ mid.name }}" data-hover="dropdown" data-toggle="dropdown" data-target="#">
                        {{ mid.short_title|default:mid.title }} <b class="caret"></b></a>
                    <ul class="dropdown-menu">
            {% else %}
                {% if mid.is_visible %}
                    <li class="{% if mid|member:parents %}active{% endif %}">
                        <a href="{{ mid.page_url }}" class="{{ mid.name }}{% if mid|member:parents %} active{% endif %}" data-target="#">
                            {{ mid.short_title|default:mid.title }}
                        </a>
                    </li>
                {% endif %}
            {% endif %}

        {% else %}
            </ul></li>
        {% endif %}
    {% if forloop.last %}{% include "_menu_extra.tpl" %}{% endif %}
    {% endfor %}
    </ul>
{% endwith %}
{% endif %}
