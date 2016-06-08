
{% with
    editing|default:q.editing|default:0,
    remark_id|default:q.remark_id,
    is_new|default:q.is_new|default:0,
    id|default:q.id|default:undefined
        as
    editing,
    remark_id,
    is_new,
    id

%}

    {% if editing == 1 %}
        {% include "remark/remark-edit.tpl" remark_id=remark_id editing=editing remark_id=remark_id id=id %}
    {% else %}
        {% include "remark/remark-view.tpl" remark_id=remark_id editing=editing remark_id=remark_id id=id %}
    {% endif %}

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

{% endjavascript %}
