
<div class="remarks do_remarks_widget" id="remarks">

    <div class="list-header" id="list-header">
        <h2 class="list-header__title">
            {{ items|length }} {% if items|length > 1 %}{_ Reacties _}{% else %}{_ Reactie _}{% endif %}
        </h2>
        <a href="#" class="remark-new" title="Add your story to this">{_ Voeg jouw verhaal hieraan toe _}</a>
    </div>

    {% with m.search[{query cat="remark" hasobject=[id,'about'] pagelen=6}] as result %}

        {% include "list/list.tpl" list_id="list--match-objects" items=result class="list--sided" list_template="list/list-item.remark.tpl" extraClasses="" id=id %}

    {% endwith %}
</div>

{% wire name="new_remark" action={insert_after target="list-header" template="remark/remark-wrapper.tpl" editing=1 is_new=1 id=id } %}
