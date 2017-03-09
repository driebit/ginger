{% with class|default:"list-search" as class %}
{% with m.search[{beeldenzoeker page=q.page index=index sort=sort text=text|default:q.qs cat=cat pagelen=20}] as result %}
	{% include results_template items=result id=id show_pager hide_showall_button hide_showmore_button noresults list_id="list-"++r.id class=class list_template="list/list-item-beeldenzoeker.tpl" %}
{% endwith %}
{% endwith %}
