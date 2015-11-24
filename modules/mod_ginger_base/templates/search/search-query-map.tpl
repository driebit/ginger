{# Add one or more cat="NAME" to the query below to filter the result #}


{%
    with
        cat,
        paged|default:true,
        cat_exclude|default:['meta', 'menu'],
        search_text|default:q.search_text|default:q.qs,
        keyword|default:q.keyword,
        cg_name,
        pagelen|default:10
    as
        cat,
        paged,
        cat_exclude,
        search_text,
        keyword,
        content_group,
        pagelen
%}

        {% with m.search[{ginger_geo cat_exclude=cat_exclude content_group=content_group text=search_text keyword=keyword }] as result %}
            {% include "map/map.tpl" result=result container="map-results" blackwhite="true" height="600" %}
        {% endwith %}

{% endwith %}
