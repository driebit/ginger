
<div class="remarks do_remarks_widget" id="remarks">

    <div class="buttons" id="buttons">
        <a href="#" id="" class="remark-new">new</a>
    </div>

    {% include "remark/remark-wrapper.tpl" remark_id=666 %}
    {% include "remark/remark-wrapper.tpl" remark_id=1000 %}

</div>

{% wire name="new_remark" action={insert_after target="buttons" template="remark/remark-wrapper.tpl" editing=1} %}
