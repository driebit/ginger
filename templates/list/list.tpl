{% with
    items,
    cols,
    extraClasses
as
    items,
    cols,
    extraClasses
%}

    <ul class="list {{ extraClasses }}">

        {% for item in items %}
            {% catinclude "list/list-item.tpl" item cols=cols %}
        {% endfor %}

    </ul>

{% endwith %}