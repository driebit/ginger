{# Add one or more cat="NAME" to the query below to filter the result #}

{%
    with
        cat,
        paged|default:true,
        cat_exclude|default:['meta', 'menu'],
        search_text|default:q.search_text|default:q.qs,
        content_group,
        result_template
    as
        cat,
        paged,
        cat_exclude,
        search_text,
        content_group,
        result_template
%}
    
    {% with m.search[{ginger_geo cat_exclude=cat_exclude content_group=content_group text=search_text}] as result %}
        {% include result_template result=result %}
    {% endwith %}

{% endwith %}
