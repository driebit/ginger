{# Search suggestions query #}

{%
    with
        results_template,
        search_text|default:q.value|default:q.qs|escape,
        pagelen|default:10
    as
        results_template,
        search_text,
        pagelen
%}
    {% include "collection/search-query-wrapper.tpl" prefix=search_text %}
{% endwith %}
