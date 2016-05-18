<div class="remark1-wrapper do_remark_widget" data-id="{{ remark_id }}" data-editing="{{ editing }}">
    <div id="remark-{{ remark_id }}-wrapper">
        {% include "remark/remark.tpl" remark_id=remark_id editing=editing %}
    </div>
</div>

{% wire name="render-remark-"++remark_id action={update target="remark-"++remark_id++"-wrapper" template="remark/remark.tpl"} %}
