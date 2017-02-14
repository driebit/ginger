{% with m.search.paged[{elastic index=index text=q.qs pagelen="20"}] as result %}
	
	{% pager result=result dispatch="beeldenzoeker_search" id=id qargs %}
	
	{% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id class="list-search" list_template="list/list-item-beeldenzoeker.tpl" %}

	{% pager result=result dispatch="beeldenzoeker_search" id=id qargs %}
{% endwith %}