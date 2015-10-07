{% with
    items,
    cols,
    extraClasses,
    class|default:"list",
    list_id|default:"",
    hide_button|default:0,
    button_text|default:_"Show more results...",
    list_template|default:"list/list-item.tpl"
as
    items,
    cols,
    extraClasses,
    class,
    list_id,
    hide_button,
    button_text,
    list_template
%}
    {% if items %}
        <ul id="{{ list_id }}" class="{{ class }} {{ extraClasses }}">

            {% for r in items %}
                {% if r|length == 2 %}
                    {% with r|element:1 as item %}
                        {% catinclude list_template item %}
                    {%  endwith %}
                {% else %}
                    {% with r as item %}
                        {% catinclude list_template item %}
                    {% endwith %}
                {% endif %}
            {% endfor %}

        </ul>

        {% if hide_button == '0' %}
            {# TODO: deze moet een catinclude doen ipv letterlijk het template #}
            {% button class="list__more" text=button_text action={moreresults result=result
                target=list_id
                template=list_template}
                %}
        {% endif %}
    {% endif %}

{% endwith %}
