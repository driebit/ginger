{% extends "base.tpl" %}

{% block page_class %}page{% endblock %}

{% block content %}
	{% block page_title %}
		<h2 class="page-header">{{ id.title }}</h2>
	{% endblock %}

	<div class="row">
		{% block page_content %}
			<article class="col-md-8">
				{% block page_image %}
					{% if id.depiction %}
						{% image id.depiction mediaclass="default" class="img-responsive" alt="" %}
					{% endif %}
				{% endblock %}

				{% block page_summary %}
					{% if id.summary %}
						<p class="summary article_summary">{{ id.summary }}</p>
					{% endif %}
				{% endblock %}

				{% block page_body %}
					{% if id.body %}
						<div class="body article_body">{{ id.body|show_media }}</div>
					{% endif %}
				{% endblock %}

				{% block page_images %}
					{% include "_images.tpl" %}
				{% endblock %}
			</article>
		{% endblock %}
	
		{% block page_aside %}
			<div class="col-md-4">
				{% include "_aside.tpl" %}
			</div>
		{% endblock %}
	</div>
{% endblock %}