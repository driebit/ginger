{% with m.search[{elastic index=index text=q.qs pagelen="20"}] as result %}
	{% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id list_template="list/list-item-beeldenzoeker.tpl" %}
{% endwith %}