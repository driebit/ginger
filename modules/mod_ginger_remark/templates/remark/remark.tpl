{% with
    editing|default:q.editing|default:0|escape,
    remark_id|default:q.remark_id,
    is_new|default:q.is_new|default:0|escape,
    id|default:q.id|default:undefined|escape
    as
    editing,
    remark_id,
    is_new,
    id
%}
    {% if editing == 1 %}
        {% include "remark/remark-edit.tpl" remark_id=remark_id editing=editing id=id %}
    {% else %}
        {% include "remark/remark-view.tpl" remark_id=remark_id editing=editing id=id %}
    {% endif %}
{% endwith %}



