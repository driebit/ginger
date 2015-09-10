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

        {% for item in items %}
            {% catinclude "list/list-item.tpl" item %}
        {% endfor %}

    </ul>

{% endwith %}
