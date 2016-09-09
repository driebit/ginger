{% with
    id.s.about|sort:[order, 'created']|filter:`category_id`:m.rsc.remark.id|filter:`is_visible`
as
    remarks
%}
    <div class="list-header" id="list-header">
        <h2 class="list-header__title">
            {{ remarks|length }} {% if remarks|length == 1 %}{_ Reaction _}{% else %}{_ Reactions _}{% endif %}
        </h2>
        {% if not show_form %}
            <a href="#" class="remark-new" title="Add your story to this">{_ Add your reaction _}</a>
        {% endif %}

    </div>

    {% include "remark-pager/remark-pager.tpl" %}

    <div id="remark-list">
       {% with page * page_length as page_end %}
       {% with page_end - page_length + 1 as page_start %}
       {% with page_end > remarks|length as is_last_page %}
           {% if remarks %}
               {% if is_last_page %}
                   {% for remark_id in remarks|slice:[page_start, remarks|length|to_integer] %}
                       {% include "remark/remark-wrapper.tpl" remark_id=remark_id %}
                   {% endfor %}
               {% else %}
                   {% for remark_id in remarks|slice:[page_start, page_end] %}
                       {% include "remark/remark-wrapper.tpl" remark_id=remark_id %}
                   {% endfor %}
               {% endif %}
           {% endif %}
       {% endwith %}
       {% endwith %}
       {% endwith %}
   </div>

    {% include "remark-pager/remark-pager.tpl" %}

{% endwith %}
