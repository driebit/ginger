{# Add one or more cat="NAME" to the query below to filter the result #}


{%
    with
        cat,
        paged|default:true,
        cat_exclude|default:['meta', 'menu'],
        search_text|default:q.search_text|default:q.qs,
        cg_name,
        pagelen|default:10
    as
        cat,
        paged,
        cat_exclude,
        search_text,
        content_group,
        pagelen
%}

        {% with m.search.paged[{query cat_exclude=cat_exclude content_group=content_group text=search_text pagelen=pagelen}] as result %}
           <div id="search-list" class="search__results__list search__result__container">
                {% include "list/list.tpl" class="list--vertical" list_id="list--query" list_template="list/list-item-vertical.tpl" items=result extraClasses="" id=id %}
            </div>
        {% endwith %}

            <div id="search-map" class="search_results__map search__result__container">

                {% with m.search[{ginger_geo cat_exclude=cat_exclude content_group=content_group text=search_text}] as result %}
                    {% include "map/map.tpl" result=result container="map-results" blackwhite="true" %}
                {% endwith %}
                
            </div>

{% endwith %}
