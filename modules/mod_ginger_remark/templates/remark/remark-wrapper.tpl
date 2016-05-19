<div class="remark-wrapper do_remark_widget" data-remarkid="{{ remark_id }}" data-id="{{ id }}" data-editing="{{ editing }}" data-isnew="{{ isnew }}" data-unique="{{ #unique }}">
    <div id="remark-{{ remark_id }}-wrapper">
        {% include "remark/remark.tpl" remark_id=remark_id editing=editing is_new=is_new %}
    </div>
</div>

{% wire name="render_remark_"++#unique action={update target="remark-"++remark_id++"-wrapper" template="remark/remark.tpl"} %}
