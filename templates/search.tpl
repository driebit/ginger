{% extends "page.query.tpl" %}

{% block content %}
	{% if q.qs %}
		{% with m.search[{query	text=q.qs}] as result %}
			{% include "_list.tpl" cols="3" items=result %}
		{% endwith %}
	{% endif %}
{% endblock %}