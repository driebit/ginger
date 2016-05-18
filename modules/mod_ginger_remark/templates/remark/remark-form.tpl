
<div class="remarks do_remarks_widget" id="remarks">

    <div class="list-header" id="list-header">
        <h2 class="list-header__title">
            {{ items|length }} {% if items|length > 1 %}{_ Reacties _}{% else %}{_ Reactie _}{% endif %}
        </h2>
        <a href="#" class="remark-new" title="Add your story to this">{_ Voeg jouw verhaal hieraan toe _}</a>
    </div>

    {% include "remark/remark-wrapper.tpl" remark_id=65259 %}
    {% include "remark/remark-wrapper.tpl" remark_id=65258 %}

</div>

{% wire name="new_remark" action={insert_after target="list-header" template="remark/remark-wrapper.tpl" editing=1 is_new=1 id=id } %}
