{% with
    m.rsc[cat],
    m.rsc[predicate],
    title|default:m.rsc[predicate].title,
    direction|default:'s'
as
    cat,
    predicate,
    title,
    direction
%}

<div class="ginger-edit__aside--{{ title }}">
    <h3 class="section-title">{{ title }}</h3>

    {% if direction == 's' %}

        {% with m.search[{query hassubject=[id, predicate.name|stringify] pagelen=6}] as result %}
             {% include "list/list.tpl" class="ginger-edit__list" items=result hide_button=1 %}
        {% endwith %}

    {% else %}

        {% with m.search[{query hasobject=[id, predicate.name|stringify] pagelen=6}] as result %}
             {% include "list/list.tpl" class="ginger-edit__list" items=result hide_button=1 %}
        {% endwith %}

    {% endif %}
</div>

{% endwith %}
