
<div class="remark" id="remark1">

    id: {{ id }}

    <div class="buttons">
        <a href="#" class="remark-edit">edit</a>
    </div>

</div>

{% javascript %}
    $(document).trigger('remark:viewing');
{% endjavascript %}
