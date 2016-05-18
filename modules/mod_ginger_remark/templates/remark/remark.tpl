
{% with
    editing|default:q.editing|default:0,
    remark_id|default:q.remark_id
        as
    editing,
    remark_id

%}


{% print remark_id %}
{% print editing %}

{% if editing == 1 %}
    {% include "remark/remark-edit.tpl" remark_id=remark_id editing=editing %}
{% else %}
    {% include "remark/remark-view.tpl" remark_id=remark_id editing=editing %}
{% endif %}

{% endwith %}
