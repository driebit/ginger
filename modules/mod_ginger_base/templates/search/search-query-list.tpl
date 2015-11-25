{# Add one or more cat="NAME" to the query below to filter the result #}

{%
    with
        cat|default:q.cat,
        paged|default:true,
        cat_exclude|default:q.cat_exclude|default:['meta', 'menu'],
        search_text|default:q.qs|default:q.search_term,
        keyword|default:q.keyword,
        date_start_year|default:q.date_start_year,
        date_start_after|default:q.date_start_after,
        date_start_before|default:q.date_start_before,
        is_findable|default:"true",
        cg_name,
        pagelen|default:10
    as
        cat,
        paged,
        cat_exclude,
        search_text,
        keyword,
        date_start_year,
        date_start_after,
        date_start_before,
        is_findable,
        content_group,
        pagelen
%}

        {% with m.search.paged[{ginger_search cat_exclude=cat_exclude content_group=content_group text=search_text pagelen=pagelen  date_start_year=date_start_year date_start_before=date_start_before date_start_after=date_start_after is_findable=is_findable keyword=keyword cat=cat }] as result %}
           
            {% include "list/list.tpl" class="list--vertical" list_id="list--query" list_template="list/list-item-vertical.tpl" items=result extraClasses="" id=id %}

        {% endwith %}

{% endwith %}
