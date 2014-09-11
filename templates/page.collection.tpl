{% extends "base.tpl" %}

{% block page_class %}collection{% endblock %}

{% block content %}
	{% block page_title %}
		<h2 class="page-header">{{ id.title }}</h2>
	{% endblock %}
	
	{% block page_content %}
		{% if id.summary or id.body %}
			<div class="row">
				<div class="col-md-4">
					{% if id.summary %}
						<p class="summary">{{ id.summary }}</p>
					{% endif %}
					{% if id.body %}
						<div class="body">{{ id.body }}</div>
					{% endif %}
				</div>
				<div class="col-md-8">
					{% include "_list.tpl" cols="2" items=id.o.haspart %}
				</div>
			</div>
		{% else %}
			{% include "_list.tpl" cols="3" items=id.o.haspart %}
		{% endif %}
	{% endblock %}
{% endblock %}