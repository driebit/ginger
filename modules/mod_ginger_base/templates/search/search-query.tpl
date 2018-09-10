{%
    with
        type|default:q.type,
        cat|default:q.cat,
        cat_exclude|default:q.cat_exclude,
        cat_promote_recent|if_undefined:['article'],
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
        list_class|default:"list--vertical",
        index|default:(m.config.mod_elasticsearch.index.value),
        collection|default:false
    as
        type,
        cat,
        cat_exclude,
        cat_promote_recent,
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
        list_class,
        index,
        collection
%}

    {% if type == "list" %}

    {% with m.search.paged[{ginger_search

            cat_exclude=cat_exclude
            cat_exclude_defaults=cat_exclude_defaults
            content_group=content_group
            text=search_text
            authoritative=authoritative
            pagelen=pagelen
            date_start_year=date_start_year
            date_start_before=date_start_before
            date_end_before=date_end_before
            date_start_after=date_start_after
            date_end_after=date_end_after
            is_findable=is_findable
            keyword=keyword
            anykeyword=anykeyword
            cat=cat
            sort=sort
            content_group=content_group
            hassubjects=hassubjects
            hasobjects=hasobjects
            hasanyobject=hasanyobject
            custompivots=custompivots
            ongoing_on_date=ongoing_on_date
            page=page
            cat_promote=cat_promote
            cat_promote_recent=cat_promote_recent
            index=index
            collection=collection
        }] as result %}
            {% include "search/list-wrapper.tpl" class=list_class list_id=list_id list_template=list_template items=result extraClasses="" id=id %}

        {% endwith %}

    {% elif type == "timeline" %}

        {% with m.search[{ginger_search
            finished
            hassubjects=hassubjects
            hasobjects=hasobjects
            hascustompivots=custompivots
            cat_exclude=cat_exclude
            cat_exclude_defaults=cat_exclude_defaults
            content_group=content_group
            text=search_text
            authoritative=authoritative
            date_start_year=date_start_year
            date_start_before=date_start_before
            date_end_before=date_end_before
            date_start_after=date_start_after
            date_end_after=date_end_after
            is_findable=is_findable
            keyword=keyword
            cat=cat
            sort=sort
            content_group=content_group
            pagelen=50
            index=index
        }] as result %}

            {% include "search/timeline-wrapper.tpl" items=result timenav_position="" start_at_slide=0 %}

        {% endwith %}

    {% else %}

        {% with m.search[{ginger_geo
            cat_exclude=cat_exclude
            cat_exclude_defaults=cat_exclude_defaults
            content_group=content_group
            text=search_text
            pagelen=pagelen
            authoritative=authoritative
            date_start_year=date_start_year
            date_start_before=date_start_before
            date_end_before=date_end_before
            date_start_after=date_start_after
            date_end_after=date_end_after
            is_findable=is_findable
            keyword=keyword
            anykeyword=anykeyword
            cat=cat
            sort=sort
            content_group=content_group
            hassubjects=hassubjects
            hasobjects=hasobjects
            hasanyobject=hasanyobject
            custompivots=custompivots
            ongoing_on_date=ongoing_on_date
        }] as result %}

            {% block search_map %}
                {% include "search/map-wrapper.tpl" result=result container="map-results" blackwhite="true" height="600" scrollwheel="true" %}
            {% endblock %}

        {% endwith %}

    {% endif %}

{% endwith %}
