{% extends "base.tpl" %}

{% block page_class %}timeline{% endblock %}

{% block container_class %}container{% endblock %}

{% block content %}
	{% block timeline_title %}
		<h2 class="page-header">{{ id.title }}</h2>
	{% endblock %}

	{% block page_content %}
        {% include "timeline/timeline.tpl" items=id.o.haspart %}
	{% endblock %}

{% endblock %}
