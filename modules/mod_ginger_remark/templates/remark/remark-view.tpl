
<div class="remark" id="remark-{{ remark_id }}">

    <h4>remark_id: {{ remark_id }}</h4>

    {{ remark_id.body }}

    <div class="buttons">
        <a href="#" class="remark-edit">edit</a>
        <a href="#" class="remark-delete">delete</a>
    </div>

</div>

{% javascript %}
    $(document).trigger('remark:viewing');
{% endjavascript %}

{% wire name="rsc_delete_"++remark_id action={dialog_delete_rsc id=remark_id on_success={script script="$(document).trigger('remark:delete', " ++ remark_id ++ ");"}} %}
