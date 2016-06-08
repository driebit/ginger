
<div class="remarks do_remarks_widget" id="remarks">

    <div class="list-header" id="list-header">
        <h2 class="list-header__title">
            {{ items|length }} {% if items|length == 1 %}{_ Reaction _}{% else %}{_ Reactions _}{% endif %}
        </h2>
        {% if m.acl.user %}
            <a href="#" class="remark-new" title="{_ Add your remark _}">{_ Add your remark _}</a>
        {% endif %}
    </div>

    {% for remark_id in id.s.about|sort:['desc', 'created']|filter:`category_id`:m.rsc.remark.id %}
        {% include "remark/remark-wrapper.tpl" remark_id=remark_id %}
    {% endfor %}
</div>

{% wire name="new_remark" action={insert_after target="list-header" template="remark/remark-wrapper.tpl" editing=1 is_new=1 id=id } %}
