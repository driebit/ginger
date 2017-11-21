{% with
    items,
    cols,
    extraClasses,
    class|default:"list",
    list_id|default:#list,
    hide_showmore_button,
    showmore_button_text|default:_"Show more results...",
    list_items_template|default:"list/list-items.tpl",
    list_template|default:"list/list-item.tpl",
    noresults|default:_"No results",
    show_pager,
    infinite_scroll
as
    items,
    cols,
    extra_classes,
    class,
    list_id,
    hide_showmore_button,
    showmore_button_text,
    list_items_template,
    list_template,
    noresults,
    show_pager,
    infinite_scroll
%}

    {% if items %}

        {% if show_pager %}
            {% include "pager/pager.tpl" %}
        {% endif %}

        <ul id="{{ list_id }}" class="{{ class }} {{ extra_classes }}">
            {% include list_items_template result=items list_id=list_id list_item_template=list_template class=class extra_classes=extra_classes %}
        </ul>

        {% if show_pager %}
            {% include "pager/pager.tpl" %}
        {% endif %}

        {% if infinite_scroll %}
            {% lazy image=undefined action={moreresults
                result=items
                target=list_id
                template=list_items_template
                list_item_template=list_template
                class=class
                extra_classes=extra_classes
                is_result_render
                visible} %}
        {% elseif not hide_showmore_button %}

            <div id="{{ list_id }}-buttons" class="list__more-nav">

                {% if not hide_showmore_button %}
                    {% button class="list__more" text=showmore_button_text action={moreresults
                        result=items
                        target=list_id
                        template=list_template
                        catinclude }
                    %}
                {% endif %}

            </div>

        {% endif %}

    {% else %}
        {% if noresults %}
            {% if noresults == "true" %}
                <p class="no-results">{_ No results _}</p>
            {% else %}
                <p class="no-results">{{ noresults }}</p>
            {% endif %}
        {% endif %}
    {% endif %}

{% endwith %}
