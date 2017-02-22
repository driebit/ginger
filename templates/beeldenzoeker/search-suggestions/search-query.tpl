{# Search suggestions query #}

{%
    with
        results_template,
        search_text|default:q.value|default:q.qs,
        pagelen|default:10
    as
        results_template,
        search_text,
        pagelen
%}
    {% include "beeldenzoeker/search-query-wrapper.tpl" text=search_text %}
{% endwith %}
