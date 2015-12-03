{# Add one or more cat="NAME" to the query below to filter the result #}

{%
    with
        cat|default:q.cat,
        cat_exclude|default:q.cat_exclude,
        search_text|default:q.qs|default:q.search_term,
        keyword|default:q.keyword,
        date_start_year|default:q.date_start_year,
        date_start_after|default:q.date_start_after,
        date_start_before|default:q.date_start_before,
        is_findable|default:"true",
        content_group|default:q.content_group,
        pagelen|default:10,
        sort|default:q.sort,
        filters|default:q.filters,
        custompivot|default:q.custompivot
    as
        cat,
        cat_exclude,
        search_text,
        keyword,
        date_start_year,
        date_start_after,
        date_start_before,
        is_findable,
        content_group,
        pagelen,
        sort,
        filters,
        custompivot
%}
  
        {% with m.search.paged[{ginger_search custompivot=custompivot cat_exclude=cat_exclude content_group=content_group text=search_text pagelen=pagelen  date_start_year=date_start_year date_start_before=date_start_before date_start_after=date_start_after is_findable=is_findable keyword=keyword cat=cat sort=sort content_group=content_group }] as result %}
           
            {% include "list/list.tpl" class="list--vertical" list_id="list--query" list_template="list/list-item-vertical.tpl" items=result extraClasses="" id=id %}

        {% endwith %}

{% endwith %}
