{% extends "base.tpl" %}

{% block page_class %}query{% endblock %}

{% block content %}
	{% with m.search.paged[{query query_id=id pagelen=24 page=q.page}] as result %}
		{% include "_list.tpl" cols="3" items=result %}
	{% endwith %}
{% endblock %}