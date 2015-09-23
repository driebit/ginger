{% extends "base.tpl" %}

{% block page_class %}query{% endblock %}

{% block content %}

	{% block page_title %}
		<h2 class="page-header">{{ id.title }}</h2>
	{% endblock %}

	{% block page_content %}
		{% with m.search.paged[{query query_id=id pagelen=24 page=q.page}] as result %}
			{% include "_list.tpl" cols="3" items=result %}
			{% pager id=id result=result hide_single_page=1 %}
		{% endwith %}
	{% endblock %}
{% endblock %}
