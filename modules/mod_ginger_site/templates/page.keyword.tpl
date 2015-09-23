{% extends "base.tpl" %}

{% block page_class %}query{% if id.name %} {{ id.name }}{% endif %}{% endblock %}

{% block content %}
	{% block page_title %}
		<h2 class="page-header">{{ id.title }}</h2>
	{% endblock %}

	{% block page_content %}
		{% with m.search.paged[{referrers id=id pagelen=24 page=q.page}] as result %}
			<div class="row list list-keyword">
				{% for r, pred in result %}
					{% include "_list_item.tpl" id=r class="col-xs-12 col-sm-6 col-md-4" %}
				{% endfor %}
			</div>
		{% endwith %}
	{% endblock %}
{% endblock %}