{# Deprecated! Use collection/search-query-wrapper.tpl instead #}






{% with
    index|default:m.config.mod_ginger_adlib_elasticsearch.index.value ++ "," ++ m.config.mod_elasticsearch.index.value,
    results_template|default:"list/list.tpl",
    cat|default:['beeldenzoeker_query']
as
    index,
    results_template,
    cat
%}
	{% include "beeldenzoeker/search-query.tpl" index=index class=class query_id=query_id %}
{% endwith %}
