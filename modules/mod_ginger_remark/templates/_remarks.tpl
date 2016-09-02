
{% with
    id.s.about|sort:['desc', 'created']|filter:`category_id`:m.rsc.remark.id|filter:`is_published`,
    remark_page|default:q.remark_page|default:1|to_integer,
    remark_page_length|default:q.remark_page_length|default:20|to_integer,
    show_form|default:false|default:q.showform
    as
    remarks,
    page,
    page_length,
    show_form %}

<div class="remarks do_remarks_widget" id="remarks" data-show_form="{{ show_form }}">

    <div class="list-header" id="list-header">
        <h2 class="list-header__title">
            {{ remarks|length }} {% if remarks|length == 1 %}{_ Reaction _}{% else %}{_ Reactions _}{% endif %}
        </h2>
        {% if not show_form %}
            <a href="#" class="remark-new" title="Add your story to this">{_ Voeg jouw verhaal hieraan toe _}</a>
        {% endif %}

    </div>

    {% include "remark-pager/remark-pager.tpl" %}

    <div id="remark-list">
        {% with page * page_length as page_end %}
        {% with page_end - page_length + 1 as page_start %}
        {% with page_end > remarks|length as is_last_page %}
            {% if remarks %}
                {% if is_last_page %}
                    {% for remark_id in remarks|slice:[page_start, remarks|length|to_integer] %}
                        {% include "remark/remark-wrapper.tpl" remark_id=remark_id %}
                    {% endfor %}
                {% else %}
                    {% for remark_id in remarks|slice:[page_start, page_end] %}
                        {% include "remark/remark-wrapper.tpl" remark_id=remark_id %}
                    {% endfor %}
                {% endif %}
            {% endif %}
        {% endwith %}
        {% endwith %}
        {% endwith %}
    </div>

    {% include "remark-pager/remark-pager.tpl" %}
</div>
{% block new_remark_wire %}
    {% wire name="new_remark" action={insert_before target="remark-list" template="remark/remark-wrapper.tpl" editing=1 is_new=1 id=id } %}
{% endblock %}

{% endwith %}

{% javascript %}

    tinyInit.toolbar="styleselect | bold italic | bullist numlist | removeformat | zmedia | link unlink | code";

    tinyInit.style_formats = [  {title: "Headers", items: [
                                {title: "Header 3", format: "h3"},
                                {title: "Header 4", format: "h4"},
                            ]},
                            {title: "Inline", items: [
                                {title: "Bold", icon: "bold", format: "bold"},
                                {title: "Italic", icon: "italic", format: "italic"},
                                {title: "Underline", icon: "underline", format: "underline"},
                                {title: "Strikethrough", icon: "strikethrough", format: "strikethrough"},
                            ]},
                            {title: "Blocks", items: [
                                {title: "Paragraph", format: "p"},
                                {title: "Blockquote", format: "blockquote"},
                            ]}
                        ]
    {% if show_form %}
        z_event('new_remark');
    {% endif %}

{% endjavascript %}

