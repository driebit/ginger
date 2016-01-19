{%
    with
        type|default:q.type,
        cat|default:q.cat,
        cat_exclude|default:q.cat_exclude,
        search_text|default:q.qs|default:q.search_term,
        keyword|default:q.keyword,
        anykeyword|default:q.anykeyword,
        date_start_year|default:q.date_start_year,
        date_start_after|default:q.date_start_after,
        date_start_before|default:q.date_start_before,
        is_findable|default:"true",
        content_group|default:q.content_group,
        pagelen|default:10,
        sort|default:q.sort,
        filters|default:q.filters,
        hassubjects|default:q.hassubjects,
        hasobjects|default:q.hasobjects,
        custompivots|default:q.custompivots,
        ongoing_on_date|default:q.ongoing_on_date
    as
        type,
        cat,
        cat_exclude,
        search_text,
        keyword,
        anykeyword,
        date_start_year,
        date_start_after,
        date_start_before,
        is_findable,
        content_group,
        pagelen,
        sort,
        filters,
        hassubjects,
        hasobjects,
        custompivots,
        ongoing_on_date
%}

    {% if type == "list" %}

{% with m.search.paged[{ginger_search

            cat_exclude=cat_exclude
            content_group=content_group
            text=search_text
            pagelen=pagelen
            date_start_year=date_start_year
            date_start_before=date_start_before
            date_start_after=date_start_after
            is_findable=is_findable
            keyword=keyword
            anykeyword=anykeyword
            cat=cat
            sort=sort
            content_group=content_group
            hassubjects=hassubjects
            hasobjects=hasobjects
            custompivots=custompivots
            ongoing_on_date=ongoing_on_date
        }] as result %}

            {% include "list/list.tpl" class="list--vertical" list_id="list--query" list_template="list/list-item-vertical.tpl" items=result extraClasses="" id=id %}

        {% endwith %}

    {% elif type == "timeline" %}

        {% with m.search[{ginger_search
            finished
            hassubjects=hassubjects
            hasobjects=hasobjects
            hascustompivots=custompivots
            cat_exclude=cat_exclude
            content_group=content_group
            text=search_text
            date_start_year=date_start_year
            date_start_before=date_start_before
            date_start_after=date_start_after
            is_findable=is_findable
            keyword=keyword
            cat=cat
            sort=sort 
            content_group=content_group
        }] as result %}

            {% include "timeline/timeline.tpl" items=result timenav_position="" start_at_slide=0 %}

        {% endwith %}

    {% else %}

        {% with m.search[{ginger_geo
            cat_exclude=cat_exclude
            content_group=content_group
            text=search_text
            pagelen=pagelen
            date_start_year=date_start_year
            date_start_before=date_start_before
            date_start_after=date_start_after
            is_findable=is_findable
            keyword=keyword
            anykeyword=anykeyword
            cat=cat
            sort=sort
            content_group=content_group
            hassubjects=hassubjects
            hasobjects=hasobjects
            custompivots=custompivots
            ongoing_on_date=ongoing_on_date
        }] as result %}

            {% include "map/map.tpl" result=result container="map-results" blackwhite="true" height="600" %}

        {% endwith %}

    {% endif %}

{% endwith %}
