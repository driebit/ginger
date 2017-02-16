{# Search suggestions query #}

{%
    with
        results_template,
        cat|default:['beeldenzoeker_query'],
        search_text|default:q.value|default:q.qs,
        pagelen|default:10
    as
        results_template,
        cat,
        search_text,
        pagelen
%}
    {% include "beeldenzoeker/search-query-wrapper.tpl" text=search_text %}
{% endwith %}
