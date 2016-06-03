
{% with
    id.s.about|sort:['desc', 'created']|filter:`category_id`:m.rsc.remark.id,
    remark_page|default:q.remark_page|default:1|to_integer,
    remark_page_length|default:q.remark_page_length|default:20|to_integer
    as
    remarks,
    page,
    page_length %}

<div class="remarks do_remarks_widget" id="remarks">

    <div class="list-header" id="list-header">
        <h2 class="list-header__title">
            {{ remarks|length }} {% if remarks|length > 1 %}{_ Reacties _}{% else %}{_ Reactie _}{% endif %}
        </h2>
        {% if m.acl.user %}
            <a href="#" class="remark-new" title="Add your story to this">{_ Voeg jouw verhaal hieraan toe _}</a>
        {% endif %}
    </div>

    {% with page * page_length as page_end %}
    {% with page_end - page_length + 1 as page_start %}
    {% with page_end > remarks|length as is_last_page %}
        {% if is_last_page %}
            {% for remark_id in remarks|slice:[page_start, remarks|length|to_integer] %}
                {% include "remark/remark-wrapper.tpl" remark_id=remark_id %}
            {% endfor %}
        {% else %}
            {% for remark_id in remarks|slice:[page_start, page_end] %}
                {% include "remark/remark-wrapper.tpl" remark_id=remark_id %}
            {% endfor %}
        {% endif %}
    {% endwith %}
    {% endwith %}
    {% endwith %}
</div>

{% with
    (remarks|length / page_length)|ceiling
    as
    total_pages
     %}

<div id="{{ list_id }}-buttons" class="search__pager">
    <div class="search__pager__result-counter">{{ remarks|length }} {_ results _}</div>
    <div class="search__pager__pagination">
        <ul class="pagination pagination-centered">
            {% if page - 1 > 0 %}
            <li><a href="?remark_page={{ page - 1}}&remark_page_length={{ page_length }}">←</a></li>
            {% endif %}
                    <!-- <li><a href="/search?page=1#content-pager">1</a></li>
                    <li class="disabled"><a href="#">…</a></li> -->
                    {% if (page - 2) > 0 %}
                    <li><a href="?remark_page={{ page - 2 }}&remark_page_length={{ page_length }}">{{ page - 2 }}</a></li>
                    {% endif %}
                    {% if (page - 1) > 0 %}
                    <li><a href="?remark_page={{ page - 1 }}&remark_page_length={{ page_length }}">{{ page - 1 }}</a></li>
                    {% endif %}
                    <li class="active">{{ page }}</li>
                    {% if (page + 1) <= total_pages %}
                    <li><a href="?remark_page={{ page + 1 }}&remark_page_length={{ page_length }}">{{ page + 1 }}</a></li>
                    {% endif %}
                    {% if (page + 2) <= total_pages %}
                    <li><a href="?remark_page={{ page + 2 }}&remark_page_length={{ page_length }}">{{ page + 2 }}</a></li>
                    {% endif %}
                    <!-- <li class="disabled"><a href="#">…</a></li>
                    <li><a href="/search?page=3000#content-pager">3000</a></li> -->
            {% if total_pages > page %}
            <li><a href="?remark_page={{ page + 1}}&remark_page_length={{ page_length }}">→</a></li>
            {% endif %}
        </ul>
    </div>
</div>
{% endwith %}

{% wire name="new_remark" action={insert_after target="list-header" template="remark/remark-wrapper.tpl" editing=1 is_new=1 id=id } %}

{% endwith %}
