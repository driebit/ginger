
<div class="remarks do_remarks_widget" id="remarks">

    <div class="list-header">
        <h2 class="list-header__title">
            {{ items|length }} {% if items|length > 1 %}{_ Reacties _}{% else %}{_ Reactie _}{% endif %}
        </h2>
        <a href="#" class="remark-new" title="Add your story to this">{_ Voeg jouw verhaal hieraan toe _}</a>
    </div>

    <div class="buttons" id="buttons">

    </div>

    {% include "remark/remark-wrapper.tpl" remark_id=666 %}
    {% include "remark/remark-wrapper.tpl" remark_id=1000 %}

</div>

{% wire name="new_remark" action={insert_after target="buttons" template="remark/remark-wrapper.tpl" editing=1} %}
