{% extends "base.tpl" %}

{% block page_class %}collection{% endblock %}

{% block content %}
	{% block page_title %}
		<h2 class="page-header">{{ id.title }}</h2>
	{% endblock %}
	
	{% block page_content %}
        {% block page_actions %}{% catinclude "_page_actions.tpl" id %}{% endblock %}
		{% if id.summary or id.body %}
			<div class="row {% block row_class %}{% endblock %}">
				<div class="col-md-4">
					
					{% block content_title %}{% endblock %}

					{% if id.summary %}
						<p class="summary">{{ id.summary }}</p>
					{% endif %}
					{% if id.body %}
						<div class="body">{{ id.body }}</div>
					{% endif %}
				</div>
				<div class="col-md-8 {% block list_right_class %}{% endblock %}">
					{% catinclude "_list.tpl" id cols="2" items=id.o.haspart %}
				</div>
			</div>
		{% else %}
			{% catinclude "_list.tpl" id cols="3" items=id.o.haspart %}
		{% endif %}
	{% endblock %}
{% endblock %}