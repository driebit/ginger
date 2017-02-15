{% with m.search[{elastic page=q.page index=index text=q.qs pagelen="20"}] as result %}
	{% include "list/list-beeldenzoeker.tpl" items=result id=id show_pager hide_showall_button hide_showmore_button list_id="list-"++r.id class="list-search" list_template="list/list-item-beeldenzoeker.tpl" %}
{% endwith %}
