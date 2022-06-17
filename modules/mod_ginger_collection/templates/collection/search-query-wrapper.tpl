{% with
    index|default:(m.ginger_collection.collection_index ++ "," ++ m.ginger_collection.default_index),
    results_template|default:"list/list.tpl",
    cat|default:['beeldenzoeker_query']
as
    index,
    results_template,
    cat
%}
	{% include "collection/search-query.tpl" index=index class=class query_id=query_id %}
{% endwith %}
