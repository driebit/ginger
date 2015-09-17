{% with
    items,
    cols,
    extraClasses,
    list_id|default:"",
    hide_button|default:0,
    button_text|default:_"Toon meer resultaten..."
as
    items,
    cols,
    extraClasses,
    list_id,
    hide_button,
    button_text
%}
    {% if items %}
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

        {% if hide_button == '0' %}
            {% button class="list__more" text=button_text action={moreresults result=result
                target=list_id
                template="list/list-item.tpl"}
                %}
        {% endif %}
    {% endif %}

{% endwith %}
