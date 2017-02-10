{# {%
    with
        type|default:q.type,
        cat|default:q.cat,
        cat_exclude|default:q.cat_exclude,
        search_text|default:q.qs|default:q.search_term,
        keyword|default:q.keyword,
        anykeyword|default:q.anykeyword,
        date_start_year|default:q.date_start_year,
        date_start_after|default:q.date_start_after,
        date_end_after|default:q.date_end_after,
        date_start_before|default:q.date_start_before,
        date_end_before|default:q.date_end_before,
        is_findable|default:"true",
        content_group|default:q.content_group,
        pagelen|default:10,
        sort|default:q.sort,
        filters|default:q.filters,
        hassubjects|default:q.hassubjects,
        hasobjects|default:q.hasobjects,
        hasanyobject|default:q.hasanyobject,
        custompivots|default:q.custompivots,
        ongoing_on_date|default:q.ongoing_on_date,
        page|default:q.page|default:1,
        cat_exclude_defaults|default:"true",
        authoritative|default:1,
        list_template|default:"list/list-item-vertical.tpl",
        list_id|default:"list--query",
        list_class|default:"list--vertical"
    as
        type,
        cat,
        cat_exclude,
        search_text,
        keyword,
        anykeyword,
        date_start_year,
        date_start_after,
        date_end_after,
        date_start_before,
        date_end_before,
        is_findable,
        content_group,
        pagelen,
        sort,
        filters,
        hassubjects,
        hasobjects,
        hasanyobject,
        custompivots,
        ongoing_on_date,
        page,
        cat_exclude_defaults,
        authoritative,
        list_template,
        list_id,
        list_class
%}
	
	{% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text=search_text}] as result %}
        {% include "search/list-wrapper.tpl" class=list_class list_id=list_id list_template=list_template items=result extraClasses="" id=id %}
    {% endwith %}    

    {% endif %}

{% endwith %}
 #}