{% with index|default:m.config.mod_ginger_adlib_elasticsearch.index.value as index %}
	{% include "beeldenzoeker/search-query.tpl" index=index %}
{% endwith %}

