{% with
    index|default:m.config.mod_ginger_adlib_elasticsearch.index.value ++ "," ++ m.config.mod_elasticsearch.index.value,
    results_template|default:"list/list-beeldenzoeker.tpl"
as
    index,
    results_template
%}
	{% include "beeldenzoeker/search-query.tpl" index=index %}
{% endwith %}

