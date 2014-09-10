{% extends "base.tpl" %}

{% block page_class %}collection{% endblock %}

{% block content %}
	{% include "_list.tpl" type="image" cols="3" items=id.o.haspart %}
{% endblock %}