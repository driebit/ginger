{% with
    items,
    cols,
    extraClasses,
    list_id|default:""
as
    items,
    cols,
    extraClasses,
    list_id
%}

    <ul id="{{ list_id }}" class="list {{ extraClasses }}">

        {% for r in items %}
            {% if r|length == 2 %}
                {% with r|element:1 as item %}
                    {% catinclude "list/list-item.tpl" item %}
                {%  endwith %}
            {% else %}
                {% with r as item %}
                    {% catinclude "list/list-item.tpl" item %}
                {% endwith %}
            {% endif %}
        {% endfor %}

    </ul>

{% endwith %}
