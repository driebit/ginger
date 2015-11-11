{% with
    items,
    cols,
    extraClasses,
    class|default:"list",
    list_id|default:"",
    hide_showmore_button,
    hide_showall_button,
    showmore_button_text|default:_"Show more results...",
    showall_button_text|default:_"Show all...",
    list_template|default:"list/list-item.tpl"
as
    items,
    cols,
    extraClasses,
    class,
    list_id,
    hide_showmore_button,
    hide_showall_button,
    showmore_button_text,
    showall_button_text,
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

            {% if not hide_showmore_button %}

                <div id="{{ list_id }}-buttons">

                    {% if not hide_showmore_button %}
                        {% button class="list__more" text=showmore_button_text action={moreresults result=result
                            target=list_id
                            template=list_template
                            catinclude }
                            %}
                    {% endif %}

                    {#
                    {% if not hide_showall_button %}

                        {% button class="list__more" text=showall_button_text
                            action={replace target=list_id template="list/list-all.tpl"}
                            action={hide target=list_id++"-buttons" }
                        %}

                    {% endif %}
                    #}

                </div>

            {% endif %}
    {% else %}
        <p class="no-results">{_ No results _}</p>
    {% endif %}

{% endwith %}
