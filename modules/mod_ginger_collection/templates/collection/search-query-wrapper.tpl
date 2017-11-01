{% with
    index|default:(m.config.mod_ginger_collection.index.value ++ "," ++ m.config.mod_elasticsearch.index.value),
    results_template|default:"list/list.tpl",
    cat|default:['beeldenzoeker_query']
as
    index,
    results_template,
    cat
%}
	{% include "collection/search-query.tpl" index=index class=class query_id=query_id %}
{% endwith %}
